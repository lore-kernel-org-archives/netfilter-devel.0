From: Thomas Heinz <creatix@hipac.org>
Subject: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 04:57:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E335CB1.9070101@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi

We all know the IPT_ALIGN macro defined in
include/linux/netfilter_ipv4/ip_tables.h:

#define IPT_ALIGN(s) (((s) + (__alignof__(struct ipt_entry)-1)) & 
~(__alignof__(struct ipt_entry)-1))

shorter:- on 32 bit architectures: output the smallest k = 4*k' >= s
           IPT_ALIGN(s) = (s + 3) & 0xffffff00
         - on 64 bit architectures: output the smallest k = 8*k' >= s
           IPT_ALIGN(s) = (s + 7) & 0xfffffffffffff000

The macro is used to align the match and target data that is transferred
from user to kernel space. Obviously we would not need such a macro
if there were no differences between the user and the kernel space
architecture which actually is the case for sparc64 and parisc64
(both 32 bit user space (possible) but 64 bit kernel space).

Now, it is interesting to have a closer look at the situations when
alignment _really_ becomes an issue, i.e. the data is aligned
differently in 32 bit user space and 64 bit kernel space.

I did a quick test on 3 machines: x86, sparc64, alpha. Each test ran in
user space only (this is not a problem if the behaviour of alpha in
user space is the same as sparc64 in kernel space as far as alignment
is concerned ... I hope this is the case :-).

Here is the ugly code:
#include <linux/types.h>
#include <stddef.h>
#include <stdio.h>

#define S(s)    (unsigned) sizeof(struct s)
#define A(s)    (unsigned) __alignof__(struct s)
#define O(s, m) (unsigned) offsetof(struct s, m)

int
main(void)
{
	struct t8
	{
		__u8 a;
		__u8 b[14];
		__u8 c;
	};
	struct t16
	{
		__u8 a;
		__u8 b[12];
		__u16 c;
		__u8 d[3];
		__u16 e[3];
	};
	struct t32
	{
		__u8 a;
		__u16 b[2];
		__u8 c;
		__u16 d[3];
		__u32 e[3];
		__u8 f;
	};
	struct t64
	{
		__u8 a;
		__u8 b[8];
		__u16 c;
		__u64 d[2];
		__u32 e;
		__u64 f;
	};
	struct tptr
	{
		__u8 a;
		void *p;
	};
	struct temb1
	{
		struct t8 a;
		struct t16 b;
	};
	struct temb2
	{
		struct t8 a;
		struct t64 b;
	};

	printf("sizeof(void *) = %u\n", (unsigned) sizeof(void *));
	printf("t8:    size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u, %2u\n", S(t8), A(t8), O(t8, a), O(t8, b), O(t8, c));
	printf("t16:   size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u, %2u, %2u, %2u\n", S(t16), A(t16), O(t16, a),
	       O(t16, b), O(t16, c), O(t16, d), O(t16, e));
	printf("t32:   size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u, %2u, %2u, %2u, %2u\n", S(t32), A(t32), O(t32, a),
	       O(t32, b), O(t32, c), O(t32, d), O(t32, e), O(t32, f));
	printf("t64:   size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u, %2u, %2u, %2u, %2u\n", S(t64), A(t64),
	       O(t64, a), O(t64, b), O(t64, c), O(t64, d), O(t64, e),
	       O(t64, f));
	printf("tptr:  size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u\n", S(tptr), A(tptr), O(tptr, a), O(tptr, p));
	printf("temb1: size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u\n", S(temb1), A(temb1), O(temb1, a), O(temb1, b));
	printf("temb2: size: %2u   struct align: %2u   member offset: "
	       "%2u, %2u\n", S(temb2), A(temb2), O(temb2, a), O(temb2, b));
	
	return 0;
}


Here is the output:
x86:
----
sizeof(void *) = 4
t8:    size: 16   struct align:  1   member offset:  0,  1, 15
t16:   size: 26   struct align:  2   member offset:  0,  1, 14, 16, 20
t32:   size: 32   struct align:  4   member offset:  0,  2,  6,  8, 16, 28
t64:   size: 40   struct align:  4   member offset:  0,  1, 10, 12, 28, 32
tptr:  size:  8   struct align:  4   member offset:  0,  4
temb1: size: 42   struct align:  2   member offset:  0, 16
temb2: size: 56   struct align:  4   member offset:  0, 16

sparc64:
--------
sizeof(void *) = 4
t8:    size: 16   struct align:  1   member offset:  0,  1, 15
t16:   size: 26   struct align:  2   member offset:  0,  1, 14, 16, 20
t32:   size: 32   struct align:  4   member offset:  0,  2,  6,  8, 16, 28
t64:   size: 48   struct align:  8   member offset:  0,  1, 10, 16, 32, 40
tptr:  size:  8   struct align:  4   member offset:  0,  4
temb1: size: 42   struct align:  2   member offset:  0, 16
temb2: size: 64   struct align:  8   member offset:  0, 16

alpha:
------
sizeof(void *) = 8
t8:    size: 16   struct align:  1   member offset:  0,  1, 15
t16:   size: 26   struct align:  2   member offset:  0,  1, 14, 16, 20
t32:   size: 32   struct align:  4   member offset:  0,  2,  6,  8, 16, 28
t64:   size: 48   struct align:  8   member offset:  0,  1, 10, 16, 32, 40
tptr:  size: 16   struct align:  8   member offset:  0,  8
temb1: size: 42   struct align:  2   member offset:  0, 16
temb2: size: 64   struct align:  8   member offset:  0, 16


Conclusions:

Except for struct tptr both sparc64 and alpha have the same struct
alignment and member offsets for all structs.
struct tptr is different because sizeof(void *) is different on alpha
and sparc64 (in user space).

Now, imagine that only those structs were allowed for which the
following properties hold:
             - basic datatype must be of fixed width (e.g. __u8, __u16,
               __u32, __u64)
             - members of the struct can be of:
                  * basic type
                  * array of basic type
                  * array of struct (for which the same properties hold)
                  * struct (for which the same properties hold)

In this case the IPT_ALIGN macro is _not_ needed!

So I come to the conclusion that if no pointers within target or match
structs would be needed IPT_ALIGN can be dropped without any
problems (if the assumption about the basic datatype holds).

What do you think about this? Am I wrong/right? Do I miss anything?
Is the stuff stated above trivially obvious ;-)?


Regards,

Thomas
