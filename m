From: "Maxx Usr" <maxx.usr@gmail.com>
Subject: iptables U32 match query
Date: Tue, 10 Apr 2007 11:27:18 +0530
Message-ID: <314bf9ab0704092257q7301665obdeca1f0f8d39cc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi All,

I am using FC5 kernel 2.6.15 and iptables v1.3.7, I am trying to
configure the following -

Extract MAC address from DHCP messages and compare with a given MAC address.
On the basis of the result I want to perform an action. To achieve
this, I want to use U32
option. But while patching 2.6.15 kernel with U32 files, kernel is
throwing the following error.

error: unknown field 'matchsize' specified in initializer
net/ipv4/netfilter/ipt_u32.c
 :220: warning: initialization makes pointer from integer without a cast
net/ipv4/netfilter/ipt_u32.c:221: warning: initialization from
incompatible pointer type
make[3]: *** [net/ipv4/netfilter/ipt_u32.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2

I tried to comment .matchentry in ipt_u32.c and then proceed. If I now
try this example ,
iptables -m u32 --u32 "12&0xFFFFFF00=0xC0A80F00"

It is giving error -
iptables v1.3.7: no command specified

Can anyone help me in this regards. Is there any other way to extract
MAC address.

Thanks
