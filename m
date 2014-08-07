From: Cormac Long <cormac.long@openmindnetworks.com>
Subject: SDP NATing issue producing invalid X.Y.0.0 IPs
Date: Thu, 7 Aug 2014 10:05:44 +0100
Message-ID: <CA+A7gQaKjTwknewq0=ssNLLoLK7nvq7udhRbuOh=+ea5gYwhRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41203 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbaHGJFr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:05:47 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so3774995wgh.13
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Aug 2014 02:05:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Folks,
   I'm having an odd issue with NATing of an SDP in a 200 OK for an
SIP INVITE. This is for an RCS 1:1 chat using the INVITE to exchange
SDP details for an MSRP connection.

I was of the opinion this may be a config issue and had posted details
to the user list. However I've discovered now that SDPs exchanged in
RTP audio call setups are being translated fine. This leads me to
suspect a bug in play or at least something weird with the SDP that
does not play well with netfilter.

I have an IMS Core for an RCS system installed in our LAN and this
uses SIP to invite a party to a chat. The SDP details are used to
exchange MSRP connection details so the two phones can set up an
anchored chat session via the core and their related NAT'd firewalls.
We're using SIP over TCP at all times. In propduction, RCS SIP will
always be over TCP + SSL.

So here is an SDP in a 200 OK being sent from the Core SBC
192.168.116.50 to the firewall LAN 192.168.128.91. The SIP data below
is for an audio call setup. I've obfuscated MSISDNs and public IP
details in these examples..

SIP/2.0 200 OK
Via: SIP/2.0/TCP
192.168.127.144:39314;received=192.168.128.91;branch=z9hG4bKPjQPfE7DnGIJnrgsuatOJpUdV8xIiF91Dl;rport=39314
From: <tel:+35387xxxxx42>;tag=23Rk46vavH9C3HNr0mzWIXnsqAy1ASXs
To: <sip:+35386xxxxx70@omn-ims.test;user=phone>;tag=yE9CdFdnlBoP2QAiPGjxIvsg.FVsMLwO
Call-ID: 0AKJCXxyPVmOoxealaW.OBE7rUmD9Voi
CSeq: 27695 INVITE
Allow: PRACK, INFO, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE,
NOTIFY, REFER, MESSAGE, OPTIONS
Contact: <sip:SDbg931-vp9pm6fn6tp7s477nmvvsjvm9dpf5ap9tuncp1m61a2aaft4t2pcj14d19r06524dbb3ok1kdevajckbi33e5r9rmel2eelnmapbnsup8mo6dd1dk2nh0g8qggvhgs8gjov80lkdsn9sfe42v4u9ppt1160000o0@192.168.116.50:5060;ob;transport=tcp>;+g.gsma.rcs.ipcall;+g.3gpp.icsi-ref="urn%3Aurn-7%3A3gpp-service.ims.icsi.mmtel";+sip.instance="<urn:gsma:imei:35251905-247682-0>"
Supported: replaces, 100rel, timer, norefersub
Session-Expires: 1800;refresher=uac
Require: timer
Content-Type: application/sdp
Content-Length: 290

v=0
o=- 3616339794 3616339795 IN IP4 192.168.116.50
s=
b=AS:84
t=0 0
a=X-nat:0
m=audio 20298 RTP/AVP 111 101
c=IN IP4 192.168.116.50
b=TIAS:64000
a=sendrecv
a=rtpmap:111 AMR-WB/16000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15
a=ssrc:212351241 cname:0197f@pj0a290b.org

Its offering the address 192.168.116.50 and port 20298 for anchoring
the RTP packets in the Core.

We then send this out to the public Internet client after NATing..

SIP/2.0 200 OK
Via: SIP/2.0/TCP
192.168.127.144:39314;received=192.168.128.91;branch=z9hG4bKPjQPfE7DnGIJnrgsuatOJpUdV8xIiF91Dl;rport=39314
From: <tel:+35387xxxxx42>;tag=23Rk46vavH9C3HNr0mzWIXnsqAy1ASXs
To: <sip:+35386xxxxx70@omn-ims.test;user=phone>;tag=yE9CdFdnlBoP2QAiPGjxIvsg.FVsMLwO
Call-ID: 0AKJCXxyPVmOoxealaW.OBE7rUmD9Voi
CSeq: 27695 INVITE
Allow: PRACK, INFO, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE,
NOTIFY, REFER, MESSAGE, OPTIONS
Contact: <sip:SDbg931-vp9pm6fn6tp7s477nmvvsjvm9dpf5ap9tuncp1m61a2aaft4t2pcj14d19r06524dbb3ok1kdevajckbi33e5r9rmel2eelnmapbnsup8mo6dd1dk2nh0g8qggvhgs8gjov80lkdsn9sfe42v4u9ppt1160000o0@8x.7x.2xx.1xx:5060;ob;transport=tcp>;+g.gsma.rcs.ipcall;+g.3gpp.icsi-ref="urn%3Aurn-7%3A3gpp-service.ims.icsi.mmtel";+sip.instance="<urn:gsma:imei:35251905-247682-0>"
Supported: replaces, 100rel, timer, norefersub
Session-Expires: 1800;refresher=uac
Require: timer
Content-Type: application/sdp
Content-Length: 288

v=0
o=- 3616339794 3616339795 IN IP4 8x.7x.2xx.1xx
s=
b=AS:84
t=0 0
a=X-nat:0
m=audio 20298 RTP/AVP 111 101
c=IN IP4 8x.7x.2xx.1xx
b=TIAS:64000
a=sendrecv
a=rtpmap:111 AMR-WB/16000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15
a=ssrc:212351241 cname:0197f@pj0a290b.org

External IP is obfuscated.. but the o= and c= are correctly NAT'd to
the external address. This audio call actually then works. So no
issues so far.

Now we try to set up an MSRP chat via INVITE and ultimately arrive at
the same point where the SBC is sending the 200 OK to the inviting
phone with the connectivity details..

SIP/2.0 200 OK
Via: SIP/2.0/TCP
192.168.127.144:39314;received=192.168.128.91;branch=z9hG4bKPjf9ZP5GD77MjfDz9gt6pN2mc3JLF21g.6;rport=39314
From: <tel:+35387xxxxx42>;tag=hzOvc6TeNckiwerc.6N5XV20IXjhu.3u
To: <sip:+35386xxxxx70@omn-ims.test;user=phone>;tag=sbufytpatvab
Call-ID: STz4QiPDoU803bV4L83ExLCmJVrlVlnw
CSeq: 3996 INVITE
Contact: <sip:SD5qjd0-vp9pm6fn6tp7c1f5nnv15i920h1j2h0hqsbqgfes2pb7uv01daba9ulbrsnb99lgahvdkrqvjov80sndsn92ce42vk18ppt1@192.168.116.50:5060;transport=tcp>;+g.oma.sip-im;+sip.instance="<urn:gsma:imei:35251905-247682-0>"
Supported: replaces, 100rel, timer, norefersub
Allow: PRACK, INFO, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE,
NOTIFY, REFER, MESSAGE, OPTIONS
Session-Expires: 1800;refresher=uac
Require: timer
Content-Type: application/sdp
Content-Length: 398

v=0
o=OpenmindAccess 1407350989 1407350989 IN IP4 192.168.116.50
s=-
c=IN IP4 192.168.116.50
t=0 0
m=message 20294 TCP/MSRP *
a=path:msrp://192.168.116.2:2855/03ed00ed;tcp
a=accept-types:application/im-iscomposing+xml message/cpim
a=accept-wrapped-types:message/imdn+xml text/plain
application/vnd.gsma.rcspushlocation+xml
application/vnd.gsma.rcs-ft-http+xml
a=sendrecv
a=setup:passive

Again its anchored in the Core to the internal 192.168.116.50 and this
time to port 20294.

But this is what we send out from the firewall after its NATing stage..

SIP/2.0 200 OK
Via: SIP/2.0/TCP
192.168.127.144:39314;received=192.168.128.91;branch=z9hG4bKPjf9ZP5GD77MjfDz9gt6pN2mc3JLF21g.6;rport=39314
From: <tel:+35387xxxxx42>;tag=hzOvc6TeNckiwerc.6N5XV20IXjhu.3u
To: <sip:+35386xxxxx70@omn-ims.test;user=phone>;tag=sbufytpatvab
Call-ID: STz4QiPDoU803bV4L83ExLCmJVrlVlnw
CSeq: 3996 INVITE
Contact: <sip:SD5qjd0-vp9pm6fn6tp7c1f5nnv15i920h1j2h0hqsbqgfes2pb7uv01daba9ulbrsnb99lgahvdkrqvjov80sndsn92ce42vk18ppt1@8x.7x.2xx.1xx:5060;transport=tcp>;+g.oma.sip-im;+sip.instance="<urn:gsma:imei:35251905-247682-0>"
Supported: replaces, 100rel, timer, norefersub
Allow: PRACK, INFO, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE,
NOTIFY, REFER, MESSAGE, OPTIONS
Session-Expires: 1800;refresher=uac
Require: timer
Content-Type: application/sdp
Content-Length: 390

v=0
o=OpenmindAccess 1407350989 1407350989 IN IP4 156.15.0.0
s=-
c=IN IP4 156.15.0.0
t=0 0
m=message 20294 TCP/MSRP *
a=path:msrp://192.168.116.2:2855/03ed00ed;tcp
a=accept-types:application/im-iscomposing+xml message/cpim
a=accept-wrapped-types:message/imdn+xml text/plain
application/vnd.gsma.rcspushlocation+xml
application/vnd.gsma.rcs-ft-http+xml
a=sendrecv
a=setup:passive

The IP is changed to 156.15.0.0 .. thats a totally bogus address. The
actual value seen will vary but will always be an X.Y.0.0 form.. the
last two subnets always being zero.

One obvious difference is that in the o= field, you see us throwing in
a product name. .OpenmindAccess. I did a quick hack on the code to
take that out and just use o=- but it made no difference. The bogus
translation still took place.

I downloaded the linux master code and had a look and to me it seems
the netfilter sip code is clued into parsing the fields correctly,
searching for the "o=" and "IN IP4" as well as "c=" + "IN IP4"
strings. I was wondering if the msrp part of the SDP was interfering
in some dodgy way. But I can't see any obvious glitch with it in terms
of how it would break netfilter.

I don't see the bogus IP addresses appearing in any output from
iptables or conntrack -E/-L. I do see the RTP NAT entries appear there
once it sets up the calls.

Any advice here on how to debug this further. Or better still if you
think this is a config-related pitfall.

The plan B for me is to put a public IP on the SBC and try to setup a
DMZ but I'd rather not go that route if possible.

Regards,
    Cormac

Cormac Long
Lead Engineer, Innovative Business Unit
Openmind Networks
www.openmindnetworks.com

-- 
 <http://www.golgi.io/>
<https://www.linkedin.com/company/openmind-networks?trk=fc_badge>   
<https://twitter.com/Openmind_Ntwks>   <http://openmindnetworks.com>
