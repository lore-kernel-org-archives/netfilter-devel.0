From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xx_nat_proto_gre: do not modify/corrupt GREv0 packets
 thought NAT
Date: Wed, 02 May 2007 15:23:34 +0200
Message-ID: <463890D6.9060605@trash.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>	<462DFD1D.1060706@trash.net>	<101c01c78829$24a70230$061010ac@intranet.dti2.net>	<4631DCA3.4020701@trash.net>
	<00ef01c788c1$e32a62e0$061010ac@intranet.dti2.net>
	<46388337.3060800@trash.net>
	<027301c78cbc$baff1cd0$061010ac@intranet.dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <027301c78cbc$baff1cd0$061010ac@intranet.dti2.net>
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
>> Applied, thanks. I removed the FIXME though since its the intended
>> behaviour and not something that needs to be fixed. I'll push it
>> to -stable as well.
> 
> 
>    Well, I don't have an opinion on the comment. My only intention was
> to reflect the fact that we do not NAT those packets as the comment states.


Yes, I left that part intact, I just removed the FIXME.

>    Just for the records:
>    The code can be made to NAT GREv0 packets with a key, at least if the
> orig and repl direction use the same key. This is the normal behaviour
> when you configure GRE tunnels on Cisco gears, Linux "ip tunnel" allows
> to use different keys for transmitting and receiving. I have tested that
> SNAT tracks the packets and that I can use several tunnels between the
> same endpoints with different keys, it did require only some minor
> modifications but to do it right it will need some more changes like to
> expand the key field to a 32bit type again all over the code.
>    If someone ever needs it, just ask.


I think the problem with this is that we don't know whether both keys
are identical at connection setup time and thus might fail to even
track the connection if they are not.

If thats not correct feel free to send a patch on top of the previous
one :)
