From: "Slagter, EM" <eslagter@wlz.nl>
Subject: Re: Possible bug ipsec and SNAT?
Date: Sat, 22 Dec 2007 11:49:51 +0100
Message-ID: <476CEBCF.1030406@wlz.nl>
References: <476903B4.8060303@wlz.nl> <47692E3D.7090008@trash.net> <476A494C.1050606@wlz.nl> <476CBED2.8050808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <476CBED2.8050808@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> Does this rule apply in the direction you do SNAT or to reply packets?
> Please post the rules including IP addresses.

After a lot more testing and tweaking it seems to be a bug in Open/SWAN
in combination with the 2.6 ipsec kernel implementation. If I create TWO
connections in /etc/ipsec.conf, one with the original source address AND
one with the SNATted source address, everything works as expected. So
apparently the bug is not in netfilter :-/

With ipsec configured as stated, it works with SNAT and DNAT like a
charm, correct, complete policy information is available in all rule
sections I use (filter-FORWARD, nat-PREROUTING and nat-POSTROUTING) :-)

Sorry for the fuzz.
