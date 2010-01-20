From: Greg Alexander <greqcs@galexander.org>
Subject: Re: Group consensus sought on nf_conntrack_sip behavior
Date: Tue, 19 Jan 2010 19:02:34 -0500
Message-ID: <20100120000234.GJ11547@goonies.be>
References: <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net> <20100119172306.GF11547@goonies.be> <4B55F54E.4020205@trash.net> <20100119182535.GG11547@goonies.be> <4B55FC78.80001@trash.net> <20100119193655.GI11547@goonies.be> <4B562BD0.8020306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shed.goonies.be ([64.62.190.177]:51471 "EHLO shed.goonies.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0ATACi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:02:38 -0500
Content-Disposition: inline
In-Reply-To: <4B562BD0.8020306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First off, you are undoubtedly correct that I did not interpret what you
were saying correctly.  But it is pointless to call me names.  Everyone
here already knows that you know more about netfilter than I do, there is
no point in using inflamatory language to make clear what was already
known.

I see now that there are two pairs of expectations set up (I only noticed
one before), and the current option controls both.  My intention was to
control only one of them, but that's not what the patch I suggested would
accomplish.  I was thus wrong, ignorant, and incorrect.  Surprised?
I'm not.

My intuition suggests that the ideal compromise is to split the
sip_direct_media option into two options, one controlling the incoming
media stream and the other controlling the outgoing media stream. This
could work well because it is very rare for the internal host to be a
pure SIP proxy (it is usually a client, no?) and it is very common for
the external host to be a pure SIP proxy (such as a telco). It provides
the possibility to allow arbitrary standard-conforming behavior by remote
peers without exposing any host on the internal network that doesn't
actually originate SIP packets.

I'm obviously going to have to learn more about how expectations are
converted into actual port forwarding assignments before I will be able to
make a more concrete recommendation.

Any comments are welcome as I embark on this quest.  Expect a patch
in a couple days.

- Greg
p.s., "troll" indicates a specific intention that does not apply here.
Perhaps you meant "ignoramus"?

