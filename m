From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Subject: Re: [PATCH] xx_nat_proto_gre: do not modify/corrupt GREv0 packets
	thought NAT
Date: Wed, 2 May 2007 15:48:29 +0200
Message-ID: <029801c78cc0$91179600$061010ac@intranet.dti2.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>	<462DFD1D.1060706@trash.net>	<101c01c78829$24a70230$061010ac@intranet.dti2.net>	<4631DCA3.4020701@trash.net>
	<00ef01c788c1$e32a62e0$061010ac@intranet.dti2.net>
	<46388337.3060800@trash.net>
	<027301c78cbc$baff1cd0$061010ac@intranet.dti2.net>
	<463890D6.9060605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, May 02, 2007 3:23 PM
Subject: Re: [PATCH] xx_nat_proto_gre: do not modify/corrupt GREv0 packets 
thought NAT


>>    The code can be made to NAT GREv0 packets with a key, at least if the
>> orig and repl direction use the same key. This is the normal behaviour
>> when you configure GRE tunnels on Cisco gears, Linux "ip tunnel" allows
>> to use different keys for transmitting and receiving. I have tested that
>> SNAT tracks the packets and that I can use several tunnels between the
>> same endpoints with different keys, it did require only some minor
>> modifications but to do it right it will need some more changes like to
>> expand the key field to a 32bit type again all over the code.
>>    If someone ever needs it, just ask.
>
>
> I think the problem with this is that we don't know whether both keys
> are identical at connection setup time and thus might fail to even
> track the connection if they are not.
>
> If thats not correct feel free to send a patch on top of the previous
> one :)

    Yes, you are right, we don't know if both keys are identical as there is 
nothing like a "key exchange" before. So we will only support, as I stated, 
the connections that have the same key. And I even did not try to DNAT the 
packets.
    I have not thinked much about it but for a "full"(only connections with 
same key) solution we would need something alongside the xt_tcpudp.c (and 
userspace code) where we could match different keys to allow the DNAT code 
to redirect the connections to different hosts.
    The SNAT part only should be easy but I don't know if that is likely to 
be accepted. What's your opinion?

    -Jorge

==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================
