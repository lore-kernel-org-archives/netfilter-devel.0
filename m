From: Gilles Espinasse <g.esp@free.fr>
Subject: iptables 1.3.4 kernel 2.4.31 string match
Date: Tue, 03 Jan 2006 14:13:52 +0100
Message-ID: <1136294032.43ba78906f44c@imp4-g19.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

[snip]
>> As I understand, iptables 1.3.4 *can* use the kernel string matching
>> available starting in kernel 2.6.14.
>>
>> However, we are using kernel 2.4.31 (which iptables 1.3.4 doc says is =
OK).
>
>So, I updated the manpage. Attached a patch that applies to netfilter SV=
N.
>
>> However, according to our "compile guy" (Thomas):
>>
>> "iptables 1.3.4 does not compile when I have strings matching.  That i=
s, the
>> string match patch does something that makes iptables 1.3.4 not compil=
e."
>
>iptables doesn't compile the string match if it's not present in the
>current kernel, eg. if you compile iptables against a linux kernel <=3D
>2.6.14, the string match won't be compiled.
>
>> So, given that we continue to use kernel 2.4.31, is their any applicab=
le
>> patch or approach;  We would like to use our kernel (2.4.31) with ipta=
bles
>> 1.3.4 and still have string matching.
>
>There's no backport available. The only existing way to add support for
>string matching is upgrading your kernel at the moment.
>

Having done a diff iptables-1.3.3 iptables-1.3.4, I extract the changes r=
elated
to string and reverse the patch against iptables-1.3.4.

It does compile and I am starting to test this solution with kernel-2.4.3=
1 and
2.4.32.
Could something prevent this solution to work?



Gilles
