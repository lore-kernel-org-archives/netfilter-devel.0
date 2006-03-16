From: Kirk Reiser <kirk@braille.uwo.ca>
Subject: Re: Possible bug with multiport?
Date: 16 Mar 2006 07:24:45 -0500
Message-ID: <x7lkvavape.fsf@speech.braille.uwo.ca>
References: <x7d5go53rf.fsf@speech.braille.uwo.ca>
	<44184AFA.5020109@trash.net> <x7irqfmsxo.fsf@speech.braille.uwo.ca>
	<4418A621.2040909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4418A621.2040909@trash.net>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> IIRC we had a bug in iptables with revision matching (which affects
> multiport), could you try the latest version?

If you want to give me a pointer to it or to cvs I'd be happy to.

To my previous problem it appears that I was mistaken.  I was trying
to use nc with port 25 when testing and forgot that our ITS department
had port 25 blocked up stream so it wasn't iptables fault at all.
Took me some tcpdump monitoring to realize the packets were never even
getting to the box running the iptables script.  Subsequent test with
multiport statements appear to be running okay so far.

  Kirk

-- 

Kirk Reiser				The Computer Braille Facility
e-mail: kirk@braille.uwo.ca		University of Western Ontario
phone: (519) 661-3061
