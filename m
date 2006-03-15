From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible bug with multiport?
Date: Thu, 16 Mar 2006 00:41:21 +0100
Message-ID: <4418A621.2040909@trash.net>
References: <x7d5go53rf.fsf@speech.braille.uwo.ca>	<44184AFA.5020109@trash.net>
	<x7irqfmsxo.fsf@speech.braille.uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Kirk Reiser <kirk@braille.uwo.ca>
In-Reply-To: <x7irqfmsxo.fsf@speech.braille.uwo.ca>
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

Kirk Reiser wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
> 
>>Please post your kernel version, your iptables version and the
>>output of iptables -vxnL.
> 
> 
> Woops!  The kernel is linux 2.6.15.6 and the iptables is 1.3.3.  I
> will have to reconstruct the script using multiport so that will take
> some time to get the iptables -vxnL.

IIRC we had a bug in iptables with revision matching (which affects
multiport), could you try the latest version?
