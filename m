From: "Grzegorz Nosek" <blackfire@metal.art.pl>
Subject: Re: MARK target extension
Date: Mon, 14 Jun 2004 20:26:06 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040614171913.M38596@metal.art.pl>
References: <Pine.LNX.4.44.0406091535410.4854-100000@filer.marasystems.com> <1087158188.11287.33.camel@ws>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=OPENWEBMAIL_ATT_0.106399807454185"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>, Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <1087158188.11287.33.camel@ws>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=OPENWEBMAIL_ATT_0.106399807454185
Content-Type: text/plain;
	charset=iso-8859-2

On Sun, 13 Jun 2004 22:23:08 +0200, Patrick McHardy wrote
> On Wed, 2004-06-09 at 15:43, Henrik Nordstrom wrote:
> > On Wed, 9 Jun 2004, Patrick McHardy wrote:
> >
> > I do agree that it is nice to have the functionality of xor. 
> > 
> > May I propose that to solve this a userspace option is added
"--xor-mark
> > value", and that mask 0 is probited in --set-mark if this
representation
> > is used.
> 
> Seems like a good way. I'm also going to add --and-mark and -
> -or-mark as alternative representations. I'll post the patch 
> before applying it to see if everyone is happy.
> 
> > > One of my concerns was that MARK and CONNMARK should look and behave
> > > the same way. We should either change CONNMARK to also use xor, or
> > > change your patch to using or. Henrik, what do you think ?
> > 
> > I have no problem adjusting CONNMARK if a acceptable notation is
found. It
> > has not yet been submitted to the kernel even if this has been favorly
> > discussed many times already.
> 
> Yes, I know. I hope it will go in soon ..
> 
> Regards
> Patrick


Hello

I'm sorry I haven't replied earlier, I had connectivity problems (my
ISP sucks really bad...). Here's the reply I prepared earlier, I've
rewritten the code from scratch and I like it. I'd love to know your
input.

Regards,
 Greg

Several-days-old reply follows:
----------------------------------------------------------------
On Thu, 10 Jun 2004 11:59:35 +0200 (CEST), Henrik Nordstrom wrote
> On Thu, 10 Jun 2004, Grzegorz Nosek wrote:
> 
> > Taking this a little bit further, why not get rid of the /mask
> > entirely as it's not exactly obvious what it means and replace them
> > with more verbose --set-mark, --or-mark, --and-mark, --xor-mark?
> 
> Because the mask is far more powerful in the --set-mark.

Please check your opinion against my new code. :)

> 
> --or-mark makes sense to add as an alternative human 
> representation as 0x80/0x80 is not very intuitive unless one 
> is used to work with masked values, and even more so if 
> value/0 is reserved for xor (mask 0 in CONNMARK is today or, 
> regardless of the value)

value/0 isn't exactly reserved for XOR, every bit of value and mask is
treated separately, so you can mix all bit operations in a single
statement. As I've written several mails before (the bits have changed
with my latest patch!):

S - a bit of the mask
R - a bit of the mark value

SR |   | operation
---+---+-----------
00 | C | clear
01 | S | set
10 | N | no-op
11 | I | invert

I think that it gives the ultimate flexibility (four operations in two
bits) at the expense of some readability, which could be accomodated in
userspace.

> 
> --and-mark also makes sense to add as an alternative 
> representation of 0/value
> 
> but both --or-mark and --and-mark can be represented in -
> -set-mark by the logics of --set-mark. It is only --xor-mark 
> which can not.
> 

With the OR in kernel code, you're right, with the XOR, anything goes.

> > One side effect would be that upon iptables-save, all ORs would change
> > to XORs "mysteriously" but there might be a way to detect ORs and
> > treat them as such (xor_mask & and_mask == 0 or thereabouts).
> 
> Eh?

That was my sleeping brain trying to say that iptables-save would work
like this:

if (mask==~0)
    print "--set-mark " value
else if (mask == value)
    print "--or-mark " value
else
    print "--and-mark " mask " --xor-mark " value

It's still smarter (and tested at least) in my current patch, though 
(of course, any comments and improvements are welcome). This version
wouldn't probably do anything remotely correct now.

> 
> xor is a special case and will always be xor. xor can not be 
> combined with anything else without extending the 
> representation, and if the representation is extended xor is 
> still cleraly separate from the other operation.

OR can be expressed easily with AND and XOR so I'm not really sure
it's needed
as a separate value.

A | B = (A & (~B)) ^ B

Anything besides AND and XOR, while useful, is only syntactic sugar.

> 
> With the following binary representation and kernel function 
> any combination of set/and/or/xor can be represented:
> 
>   unsigned long value, mask, xor;
> 
>   newvalue = ((oldvalue & mask) | value) ^ xor;
> 
> or alternatively
> 
>   newvalue = ((oldvalue ^ xor ) & mask ) | value)
> 

But still, I don't see how it allows for anything more than a simple

   newvalue = (oldvalue & mask) ^ value;

BTW, I changed the `~mask' into `mask' in my kernel code, I can't seem to
remember the purpose of the negation.

> Userspace operations:
> 
>   --set-mark
> 
>       value |= specified_value;
>       if (mask specified)
>           mask |= specified_mask;
>       else
>           mask = ~0;
> 
>   --or-mark
> 
>       value |= specified_value;
>       mask |= specified_value;
> 
>   --and-mark becomes
> 
>       if (mask = 0)
>           mask = ~0;
>       mask &= specified_value;
> 
>   --xor-mark becomes
> 
>       if (mask = 0)
>           mask = ~0;
>       xor |= specified_value;
> 
> If you like there can be appropriate asserts to alert the 
> user if he is specifying conflicting operations on the same 
> bit, but I am not sure if this is needed other than for xor.
> 

After I scratched my head for a while on this issue (esp. overlapping
masks), I came up with a solution which:
+ is (IMHO) very user-friendly (I'd say DWIM)
+ is extremely flexible (unlimited number and unrestricted order of 
expressions)
- almost doubled the size of libipt_MARK.c
- may not be developer-friendly (obvious operation traded for a bit of
non-obvious implementation)
- may be overkill but I like it

I'll hopefully explain the basis of this idea below. (this might go 
into some README if the MARK target ever gets one)

Theory of operation
-------------------

The new MARK-ops algorithm is based on the fact that any bit can be
transformed in one of 4 ways: clear (00), set (01), no-op (10), invert
(11). Now, the elementary operations are defined as follows (by
examples, lowest 4 bits only):

--set-mark 1/3
	NNCS (leave top 2 bits alone, clear bit 1 and set bit 0)

It can be expressed as a value + mask pair:
m=1100 (~specified_mask)
v=0001 (specified_value)
Read vertically, the (mv) values are the same as the numbers in
parentheses above.

--and-mark 3
	CCNN (clear top 2 bits)
m=0011 (specified_value)
v=0000 (always zero)

--xor-mark 3
	NNII (invert lowest 2 bits)
m=1111 (always ones)
v=0011 (specified_value)

--or-mark 3
	NNSS (set lowest 2 bits)
m=1100 (~specified_value)
v=0011 (specified_value)

Now, this isn't in any way new or innovative and by itself it only
enables us to specify a single command per rule - definitely not 
enough. However, now we define a state diagram which tells us what the 
result of superimposing two states is:

 |CSIN
-+----
C|CSSC
S|CSCS
I|CSNI
N|CSIN

So, if you want to see what should happen to a bit which is set first
and then inverted, you consult the "S" row and "I" column and you know 
that it should be cleared (no surprise). So now we have a state machine 
whose state is represented by nth bit of mask and value (32 independent 
state machines, actually). For example:

--set-mark 1/3 --xor-mark 6

This statement is parsed starting with the --set-mark. We get NNCS 
encoded in mask and value and now we get to the xor. It gives NIIN and 
now we check the state diagram to check what happens to each of the 
bits:
 (bit 3) NN -> N
 (bit 2) NI -> I
 (bit 1) CI -> S
 (bit 0) SN -> S

So now we have the state NISS, which means "don't touch bit 3, invert 
bit 2 and set the lowest 2 ones". It's stored as:
m=1100
v=0111
which is the form directly used inside the kernel.

(old_mark & 0b1100) ^ 0b0111 (kernel code) is completely equivalent to 
what you might expect: ((old_mark & 0b1100) | 0b0001) ^ 0b0110 but 
does the calculation using only 2 logical operations.

Implementation details
----------------------

Replacing symbols (C,S,I,N) with their numerical values (00,01,11,10) 
we get the following table:

MV|00 01 11 10
--+-----------
00|00 01 01 00
01|00 01 00 01
11|00 01 10 11
10|00 01 11 10

It contains two-bit values which can be written in separate Karnaugh
tables:

M |00 01 11 10    V |00 01 11 10
--+-----------    --+-----------
00| 0  0  0  0    00| 0  1  1  0
01| 0  0  0  0    01| 0  1  0  1
11| 0  0  1  1    11| 0  1  0  1
10| 0  0  1  1    10| 0  1  1  0

Given that the two bits designating row are m0,v0 and m1,v1 designate 
the column, we can express the tables as the following functions:

M = m0 & m1
V = v1 ^ (v0 & m1)

And this is what function transfer_value() does. It probably is possible
to find these equations somehow simpler, without several pages of 
explanations, however this documents how I came up with these. Comments 
welcome, of course.

So in the end it turns out (for me at least) that although you may
specify the operation using the set-mark mask, it is unneccessary as 
now you can give the parameters in a mostly natural language (OR this, 
then XOR that and SET another...). And if you write some complex 
expression, you also get its simple{r,st} version for free. I think 
that given this power in --xxx-mark the internal representation 
(visible in VALUE/MASK) is mostly irrelevant as the user won't see it 
anyway.

> Regards
> Henrik

Regards,
 Greg


------=OPENWEBMAIL_ATT_0.106399807454185
Content-Type: application/octet-stream;
	name="linux-2.4.26-mark.diff"
Content-Disposition: attachment; filename="linux-2.4.26-mark.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtTmF1ciBsaW51eC0yLjQuMjYtb3cxK3JvdXRlL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVy
X2lwdjQvaXB0X01BUksuaCBsaW51eC0yLjQuMjYtb3cxK3JvdXRlLW1hcmsvaW5jbHVkZS9saW51
eC9uZXRmaWx0ZXJfaXB2NC9pcHRfTUFSSy5oCi0tLSBsaW51eC0yLjQuMjYtb3cxK3JvdXRlL2lu
Y2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjQvaXB0X01BUksuaAkyMDAwLTAzLTE3IDE5OjU2OjIw
LjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi40LjI2LW93MStyb3V0ZS1tYXJrL2luY2x1ZGUv
bGludXgvbmV0ZmlsdGVyX2lwdjQvaXB0X01BUksuaAkyMDA0LTA1LTI2IDE3OjEwOjI2LjAwMDAw
MDAwMCArMDIwMApAQCAtMyw2ICszLDcgQEAKIAogc3RydWN0IGlwdF9tYXJrX3RhcmdldF9pbmZv
IHsKIAl1bnNpZ25lZCBsb25nIG1hcms7CisJdW5zaWduZWQgbG9uZyBtYXNrOwogfTsKIAogI2Vu
ZGlmIC8qX0lQVF9NQVJLX0hfdGFyZ2V0Ki8KZGlmZiAtTmF1ciBsaW51eC0yLjQuMjYtb3cxK3Jv
dXRlL25ldC9pcHY0L25ldGZpbHRlci9pcHRfTUFSSy5jIGxpbnV4LTIuNC4yNi1vdzErcm91dGUt
bWFyay9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X01BUksuYwotLS0gbGludXgtMi40LjI2LW93MSty
b3V0ZS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X01BUksuYwkyMDAxLTA5LTMwIDIxOjI2OjA4LjAw
MDAwMDAwMCArMDIwMAorKysgbGludXgtMi40LjI2LW93MStyb3V0ZS1tYXJrL25ldC9pcHY0L25l
dGZpbHRlci9pcHRfTUFSSy5jCTIwMDQtMDYtMTIgMDE6MDY6MDYuMDAwMDAwMDAwICswMjAwCkBA
IC0xNiw5ICsxNiwxMCBAQAogICAgICAgIHZvaWQgKnVzZXJpbmZvKQogewogCWNvbnN0IHN0cnVj
dCBpcHRfbWFya190YXJnZXRfaW5mbyAqbWFya2luZm8gPSB0YXJnaW5mbzsKKwlsb25nIG5ld19t
YXJrID0gKCgqcHNrYiktPm5mbWFyayAmIG1hcmtpbmZvLT5tYXNrKSB8IG1hcmtpbmZvLT5tYXJr
OwogCi0JaWYoKCpwc2tiKS0+bmZtYXJrICE9IG1hcmtpbmZvLT5tYXJrKSB7Ci0JCSgqcHNrYikt
Pm5mbWFyayA9IG1hcmtpbmZvLT5tYXJrOworCWlmKCgqcHNrYiktPm5mbWFyayAhPSBuZXdfbWFy
aykgeworCQkoKnBza2IpLT5uZm1hcmsgPSBuZXdfbWFyazsKIAkJKCpwc2tiKS0+bmZjYWNoZSB8
PSBORkNfQUxURVJFRDsKIAl9CiAJcmV0dXJuIElQVF9DT05USU5VRTsK

------=OPENWEBMAIL_ATT_0.106399807454185
Content-Type: application/octet-stream;
	name="iptables-1.2.9-mark.diff"
Content-Disposition: attachment; filename="iptables-1.2.9-mark.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtTmF1ciBpcHRhYmxlcy0xLjIuOS9leHRlbnNpb25zL2xpYmlwdF9NQVJLLmMgaXB0YWJs
ZXMtMS4yLjktbWFyay9leHRlbnNpb25zL2xpYmlwdF9NQVJLLmMKLS0tIGlwdGFibGVzLTEuMi45
L2V4dGVuc2lvbnMvbGliaXB0X01BUksuYwkyMDAzLTAzLTAyIDE3OjE2OjQ1LjAwMDAwMDAwMCAr
MDEwMAorKysgaXB0YWJsZXMtMS4yLjktbWFyay9leHRlbnNpb25zL2xpYmlwdF9NQVJLLmMJMjAw
NC0wNi0xMiAwMzoyNjoyMy4wMDAwMDAwMDAgKzAyMDAKQEAgLTMsNiArMyw3IEBACiAjaW5jbHVk
ZSA8c3RyaW5nLmg+CiAjaW5jbHVkZSA8c3RkbGliLmg+CiAjaW5jbHVkZSA8Z2V0b3B0Lmg+Cisj
aW5jbHVkZSA8ZXJybm8uaD4KIAogI2luY2x1ZGUgPGlwdGFibGVzLmg+CiAjaW5jbHVkZSA8bGlu
dXgvbmV0ZmlsdGVyX2lwdjQvaXBfdGFibGVzLmg+CkBAIC0xOSwxMyArMjAsMjEgQEAKIHsKIAlw
cmludGYoCiAiTUFSSyB0YXJnZXQgdiVzIG9wdGlvbnM6XG4iCi0iICAtLXNldC1tYXJrIHZhbHVl
ICAgICAgICAgICAgICAgICAgIFNldCBuZm1hcmsgdmFsdWVcbiIKKyIgIC0tc2V0LW1hcmsgdmFs
dWVbL21hc2tdICAgICAgICAgICAgU2V0IG5mbWFyayB2YWx1ZVxuIgorIiAgLS1hbmQtbWFyayB2
YWx1ZSAgICAgICAgICAgICAgICAgICBQZXJmb3JtIGxvZ2ljYWwgQU5EIG9uIG5mbWFyayBhbmQg
dmFsdWVcbiIKKyIgIC0teG9yLW1hcmsgdmFsdWUgICAgICAgICAgICAgICAgICAgUGVyZm9ybSBs
b2dpY2FsIFhPUiBvbiBuZm1hcmsgYW5kIHZhbHVlXG4iCisiICAtLW9yLW1hcmsgdmFsdWUgICAg
ICAgICAgICAgICAgICAgIFBlcmZvcm0gbG9naWNhbCBPUiBvbiBuZm1hcmsgYW5kIHZhbHVlXG4i
CisiXG4iCisiT3B0aW9ucyBjYW4gYmUgc3BlY2lmaWVkIG11bHRpcGxlIHRpbWVzLCBpbiBhbnkg
b3JkZXIuXG4iCiAiXG4iLAogSVBUQUJMRVNfVkVSU0lPTik7CiB9CiAKIHN0YXRpYyBzdHJ1Y3Qg
b3B0aW9uIG9wdHNbXSA9IHsKIAl7ICJzZXQtbWFyayIsIDEsIDAsICcxJyB9LAorCXsgImFuZC1t
YXJrIiwgMSwgMCwgJzInIH0sCisJeyAieG9yLW1hcmsiLCAxLCAwLCAnMycgfSwKKwl7ICJvci1t
YXJrIiwgMSwgMCwgJzQnIH0sCiAJeyAwIH0KIH07CiAKQEAgLTMzLDYgKzQyLDM4IEBACiBzdGF0
aWMgdm9pZAogaW5pdChzdHJ1Y3QgaXB0X2VudHJ5X3RhcmdldCAqdCwgdW5zaWduZWQgaW50ICpu
ZmNhY2hlKQogeworCXN0cnVjdCBpcHRfbWFya190YXJnZXRfaW5mbyAqbWFya2luZm8KKwkJPSAo
c3RydWN0IGlwdF9tYXJrX3RhcmdldF9pbmZvICopdC0+ZGF0YTsKKworCW1hcmtpbmZvLT5tYXNr
ID0gfjBVTDsKK30KKworLyogRXh0cmFjdCB2YWx1ZS9tYXNrIGZyb20gYSBzdHJpbmcgKi8KK3N0
YXRpYyB2b2lkCitwYXJzZV9hcmcoY2hhciogb3B0YXJnLCBzdHJ1Y3QgaXB0X21hcmtfdGFyZ2V0
X2luZm8qIG1hcmtpbmZvLCBpbnQgbWFza192YWxpZCkKK3sKKwljaGFyICp0YWlsLCAqdGFpbDI7
CisJZXJybm8gPSAwOworCW1hcmtpbmZvLT5tYXJrID0gc3RydG91bChvcHRhcmcsICZ0YWlsLCAw
KTsKKwlpZiAoZXJybm8gfHwgKG9wdGFyZyA9PSB0YWlsKSkKKwkJZXhpdF9lcnJvcihQQVJBTUVU
RVJfUFJPQkxFTSwgIkJhZCBNQVJLIHZhbHVlIGAlcyciLCBvcHRhcmcpOworCWlmICgqdGFpbCkg
eworCQlpZiAoIW1hc2tfdmFsaWQgfHwgKnRhaWwgIT0gJy8nKQorCQkJZXhpdF9lcnJvcihQQVJB
TUVURVJfUFJPQkxFTSwgIkJhZCBNQVJLIHZhbHVlIGAlcyciLCBvcHRhcmcpOworCQllcnJubyA9
IDA7CisJCW1hcmtpbmZvLT5tYXNrID0gc3RydG91bCh0YWlsKzEsICZ0YWlsMiwgMCk7CisJCWlm
IChlcnJubyB8fCAodGFpbDIgPT0gdGFpbCsxKSkKKwkJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BS
T0JMRU0sICJCYWQgbWFzayB2YWx1ZSBgJXMnIiwgdGFpbCsxKTsKKwl9Cit9CisKKy8qIFN0YXRl
IHRyYW5zZmVyIGZ1bmN0aW9uIGZvciBzdWJzZXF1ZW50IG9wZXJhdGlvbnMgb24KKyAgIHRoZSBz
YW1lIGJpdCBpbiBuZm1hcmsgKi8KK3N0YXRpYyB2b2lkCit0cmFuc2Zlcl92YWx1ZShzdHJ1Y3Qg
aXB0X21hcmtfdGFyZ2V0X2luZm8gKm1hcmtpbmZvLCBzdHJ1Y3QgaXB0X21hcmtfdGFyZ2V0X2lu
Zm8gb3ApCit7CisJbWFya2luZm8tPm1hcmsgPSBvcC5tYXJrIF4gKG1hcmtpbmZvLT5tYXJrICYg
b3AubWFzayk7CisJbWFya2luZm8tPm1hc2sgJj0gb3AubWFzazsKIH0KIAogLyogRnVuY3Rpb24g
d2hpY2ggcGFyc2VzIGNvbW1hbmQgb3B0aW9uczsgcmV0dXJucyB0cnVlIGlmIGl0CkBAIC00NCwy
MiArODUsMzkgQEAKIHsKIAlzdHJ1Y3QgaXB0X21hcmtfdGFyZ2V0X2luZm8gKm1hcmtpbmZvCiAJ
CT0gKHN0cnVjdCBpcHRfbWFya190YXJnZXRfaW5mbyAqKSgqdGFyZ2V0KS0+ZGF0YTsKKwlzdHJ1
Y3QgaXB0X21hcmtfdGFyZ2V0X2luZm8gb3A7CiAKIAlzd2l0Y2ggKGMpIHsKIAljYXNlICcxJzoK
LQkJaWYgKHN0cmluZ190b19udW1iZXIob3B0YXJnLCAwLCAweGZmZmZmZmZmLCAKLQkJCQkgICAg
ICh1bnNpZ25lZCBpbnQgKikmbWFya2luZm8tPm1hcmspKQotCQkJZXhpdF9lcnJvcihQQVJBTUVU
RVJfUFJPQkxFTSwgIkJhZCBNQVJLIHZhbHVlIGAlcyciLCBvcHRhcmcpOwotCQlpZiAoKmZsYWdz
KQotCQkJZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwKLQkJCSAgICAgICAgICAgIk1BUksg
dGFyZ2V0OiBDYW4ndCBzcGVjaWZ5IC0tc2V0LW1hcmsgdHdpY2UiKTsKLQkJKmZsYWdzID0gMTsK
KwkJcGFyc2VfYXJnKG9wdGFyZywgJm9wLCAxKTsKKwkJaWYgKCFvcC5tYXNrKQorCQkJb3AubWFz
ayA9IDA7CisJCWVsc2UKKwkJCW9wLm1hc2sgXj0gfjBVTDsKKwkJYnJlYWs7CisKKwljYXNlICcy
JzoKKwkJcGFyc2VfYXJnKG9wdGFyZywgJm9wLCAwKTsKKwkJb3AubWFzayA9IG9wLm1hcms7CisJ
CW9wLm1hcmsgPSAwOworCQlicmVhazsKKworCWNhc2UgJzMnOgorCQlwYXJzZV9hcmcob3B0YXJn
LCAmb3AsIDApOworCQlvcC5tYXNrID0gfjBVTDsKKwkJYnJlYWs7CisKKwljYXNlICc0JzoKKwkJ
cGFyc2VfYXJnKG9wdGFyZywgJm9wLCAxKTsKKwkJb3AubWFzayA9IH5vcC5tYXJrOwogCQlicmVh
azsKIAogCWRlZmF1bHQ6CiAJCXJldHVybiAwOwogCX0KIAorCXRyYW5zZmVyX3ZhbHVlKG1hcmtp
bmZvLCBvcCk7CisJKmZsYWdzID0gMTsKIAlyZXR1cm4gMTsKIH0KIApAQCAtNjgsMTMgKzEyNiwy
NCBAQAogewogCWlmICghZmxhZ3MpCiAJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sCi0J
CSAgICAgICAgICAgIk1BUksgdGFyZ2V0OiBQYXJhbWV0ZXIgLS1zZXQtbWFyayBpcyByZXF1aXJl
ZCIpOworCQkgICAgICAgICAgICJNQVJLIHRhcmdldDogQSBwYXJhbWV0ZXIgaXMgcmVxdWlyZWQg
KHNlZSAtaiBNQVJLIC0taGVscCkiKTsKIH0KIAogc3RhdGljIHZvaWQKLXByaW50X21hcmsodW5z
aWduZWQgbG9uZyBtYXJrLCBpbnQgbnVtZXJpYykKK3ByaW50X21hcmsodW5zaWduZWQgbG9uZyBt
YXJrLCB1bnNpZ25lZCBsb25nIG1hc2ssIGludCBudW1lcmljKQogewotCXByaW50ZigiMHglbHgg
IiwgbWFyayk7CisJaWYgKG1hc2sgPT0gMCkKKwkJcHJpbnRmKCJzZXQgMHglbHggIiwgbWFyayk7
CisJZWxzZSBpZiAobWFyayA9PSB+bWFzaykKKwkJcHJpbnRmKCJvciAweCVseCAiLCBtYXJrKTsK
KwllbHNlIGlmICgobWFyayAmIG1hc2spID09IDApCisJCXByaW50Zigic2V0IDB4JWx4LzB4JWx4
ICIsIG1hcmssIH5tYXNrKTsKKwllbHNlIHsKKwkJaWYgKG1hc2sgIT0gfjBVTCkKKwkJCXByaW50
ZigiYW5kIDB4JWx4ICIsIG1hc2spOworCQlpZiAobWFyaykKKwkJCXByaW50ZigieG9yIDB4JWx4
ICIsIG1hcmspOworCX0KIH0KIAogLyogUHJpbnRzIG91dCB0aGUgdGFyZ2luZm8uICovCkBAIC04
NSw4ICsxNTQsOCBAQAogewogCWNvbnN0IHN0cnVjdCBpcHRfbWFya190YXJnZXRfaW5mbyAqbWFy
a2luZm8gPQogCQkoY29uc3Qgc3RydWN0IGlwdF9tYXJrX3RhcmdldF9pbmZvICopdGFyZ2V0LT5k
YXRhOwotCXByaW50ZigiTUFSSyBzZXQgIik7Ci0JcHJpbnRfbWFyayhtYXJraW5mby0+bWFyaywg
bnVtZXJpYyk7CisJcHJpbnRmKCJNQVJLICIpOworCXByaW50X21hcmsobWFya2luZm8tPm1hcmss
IG1hcmtpbmZvLT5tYXNrLCBudW1lcmljKTsKIH0KIAogLyogU2F2ZXMgdGhlIHVuaW9uIGlwdF90
YXJnaW5mbyBpbiBwYXJzYWJsZSBmb3JtIHRvIHN0ZG91dC4gKi8KQEAgLTk2LDcgKzE2NSwxOCBA
QAogCWNvbnN0IHN0cnVjdCBpcHRfbWFya190YXJnZXRfaW5mbyAqbWFya2luZm8gPQogCQkoY29u
c3Qgc3RydWN0IGlwdF9tYXJrX3RhcmdldF9pbmZvICopdGFyZ2V0LT5kYXRhOwogCi0JcHJpbnRm
KCItLXNldC1tYXJrIDB4JWx4ICIsIG1hcmtpbmZvLT5tYXJrKTsKKwlpZiAobWFya2luZm8tPm1h
c2sgPT0gMCkKKwkJcHJpbnRmKCItLXNldC1tYXJrIDB4JWx4ICIsIG1hcmtpbmZvLT5tYXJrKTsK
KwllbHNlIGlmIChtYXJraW5mby0+bWFyayA9PSB+bWFya2luZm8tPm1hc2spCisJCXByaW50Zigi
LS1vci1tYXJrIDB4JWx4ICIsIG1hcmtpbmZvLT5tYXJrKTsKKwllbHNlIGlmICgobWFya2luZm8t
Pm1hcmsgJiBtYXJraW5mby0+bWFzaykgPT0gMCkKKwkJcHJpbnRmKCItLXNldC1tYXJrIDB4JWx4
LzB4JWx4ICIsIG1hcmtpbmZvLT5tYXJrLCB+bWFya2luZm8tPm1hc2spOworCWVsc2UgeworCQlp
ZiAobWFya2luZm8tPm1hc2sgIT0gfjBVTCkKKwkJCXByaW50ZigiLS1hbmQtbWFyayAweCVseCAi
LCBtYXJraW5mby0+bWFzayk7CisJCWlmIChtYXJraW5mby0+bWFyaykKKwkJCXByaW50ZigiLS14
b3ItbWFyayAweCVseCAiLCBtYXJraW5mby0+bWFyayk7CisJfQogfQogCiBzdGF0aWMK

------=OPENWEBMAIL_ATT_0.106399807454185--
