From: Dmitry Mishin <dim@sw.ru>
Subject: Re: compat_xt_counters is not compatible
Date: Sat, 15 Apr 2006 20:14:45 +0400
Message-ID: <200604152014.45923.dim@sw.ru>
References: <jeacaoqdxn.fsf@sykes.suse.de> <200604151811.54013.dim@sw.ru>
	<jeejzykjpa.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <jeejzykjpa.fsf@sykes.suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Could you give more details on what's wrong?

dim@dhcp0-24:~> cat test.c
#include <linux/types.h>

struct x
{
        __u64 ptr;
        __u32 ptr2;
};

int main(int argc, char *argv[])
{
        printf("%d\n", sizeof(struct x));
        return 0;
}
dim@dhcp0-24:~>  gcc -m32 -o test test.c
dim@dhcp0-24:~> ./test 
12
dim@dhcp0-24:~> gcc -o test test.c
dim@dhcp0-24:~> ./test 
16
dim@dhcp0-24:~> uname -p
x86_64

On Saturday 15 April 2006 18:16, Andreas Schwab wrote:
> Dmitry Mishin <dim@sw.ru> writes:
> > compat_xt_counters should be used only for 32bit processes, which has 4
> > byte alignment.
>
> This is wrong.
>
> Andreas.

-- 
Thanks,
Dmitry.
