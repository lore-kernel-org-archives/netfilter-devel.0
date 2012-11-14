From: =?UTF-8?Q?J=C3=B6rn_Krebs?= <jk@smartbyte.de>
Subject: VoIP conntrack issue
Date: Thu, 15 Nov 2012 09:41:21 +1100
Message-ID: <CABY2qi8n0ttC99_UktcT+Jwnd9WCCsvk5+ug1GXrrYbd9ixxWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55864 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2KNWlm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:41:42 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so1049852obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Nov 2012 14:41:41 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys,

I have an issue, and I need a full symmetric NAT router (I already
posted that on the users list).

I use this for VoIP UDP only connections, so it doesn't have to work wi=
th TCP!
To make it short I need to cover the following first two NAT cases
(which is called symetric NAT)

Case 1)
A:5000 <-> router:5000 <-> C
A:5000 <-> router:5000 <-> D

Case 2)
A:5000 <-> router:5000 <-> C
B:5000 <-> router:5000 <-> D

Case 3)
What doesn't work for obvious reasons is:
A:5000 <-> router:5000 <-> C
B:5000 <-> router:5000 <-> C


The problem I have with case 1 is that Linux is assigning a new externa=
l port.
So and my router Case 1 looks more like this:
A:5000 <-> router:5000 <-> C
A:5000 <-> router:1030 <-> D
Which causes a big issue with my VoIP setup!
(VoIP is negotiating the ports inside the SIP protocol. They are not
detected and they are fixed and not detected on the fly)

Is there any flag or anything else I can do or setup up to make my
Linux router to be able to cover Case 1 & esp. 2 for UDP?
So can some developer help me?

Short SIP intro of what is going on, and why I need to re-use a port nu=
mber.
1) Client A -> (router) -> VoIP Server (RTP port of Client A defined
here, lets say 3000)

2) VoIP Server -> VoIP Provider (RTP port of Provider defined here,
lets say 4000)

3) VoIP Server -> (router) -> Client A (defines local Temp RTP Port
lets say 5001)

4) VoIP Server -> (router) -> VoIP Provider (defines local Temp RTP
Portlets say 5002)

5) RTP flow is: Client A:3000 <-> (router):3000 <-> 5001:Voip
Server:5002 -> VoIP Provider:4000 (Uhhh this is dodgy an unneded)
    We now try to set up Client A -> (router) -> VoIP Provider (for
the RTP stream)

6) VoIP Server -> (router) -> Client A (tells Client A the RTP data
which is IPAdr:4000 of VoIP Provider)

7) VoIP Server -> VoIP Provider (tells VoIP Provider the RTP data
which is IPAdr:3000 of Client A)

8) Client A:3000 -> (router):1025 -> VoIP Provider:4000 (but because
we reuse the same port from 1) netfilter does a port remapping so uses
a different external port, as it thinks it is taken by a different
connection...)

9) VoIP Provider:4000 -> (router):3000  (Gets rejected because the
known RTP port is used for the connection with the VoIP Server, and
the connection from Client A -> VoIP provider has been remapped to a
different port (1025 in this case), which is unknown to the VoIP
provider so the connection fails)

(Hope I made my case clear)

--
Bye Bye, J=C3=B6rn Krebs
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
