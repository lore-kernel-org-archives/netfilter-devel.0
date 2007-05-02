From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xx_nat_proto_gre: do not modify/corrupt GREv0 packets
 thought NAT
Date: Wed, 02 May 2007 15:52:56 +0200
Message-ID: <463897B8.1090306@trash.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>	<462DFD1D.1060706@trash.net>	<101c01c78829$24a70230$061010ac@intranet.dti2.net>	<4631DCA3.4020701@trash.net>
	<00ef01c788c1$e32a62e0$061010ac@intranet.dti2.net>
	<46388337.3060800@trash.net>
	<027301c78cbc$baff1cd0$061010ac@intranet.dti2.net>
	<463890D6.9060605@trash.net>
	<029801c78cc0$91179600$061010ac@intranet.dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <029801c78cc0$91179600$061010ac@intranet.dti2.net>
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

Jorge Boncompte [DTI2] wrote:
> ----- Original Message ----- From: "Patrick McHardy" <kaber@trash.net>
>> I think the problem with this is that we don't know whether both keys
>> are identical at connection setup time and thus might fail to even
>> track the connection if they are not.
> 
> 
>    Yes, you are right, we don't know if both keys are identical as there
> is nothing like a "key exchange" before. So we will only support, as I
> stated, the connections that have the same key. And I even did not try
> to DNAT the packets.


The problem is that this at the same time causes us *not* to work
properly anymore with connections with different keys, right?

>    I have not thinked much about it but for a "full"(only connections
> with same key) solution we would need something alongside the
> xt_tcpudp.c (and userspace code) where we could match different keys to
> allow the DNAT code to redirect the connections to different hosts.
>    The SNAT part only should be easy but I don't know if that is likely
> to be accepted. What's your opinion?


I'll take it a patch if doesn't break something else (like connections
with different keys).
