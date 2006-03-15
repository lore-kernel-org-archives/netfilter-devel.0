From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible bug with multiport?
Date: Wed, 15 Mar 2006 18:12:26 +0100
Message-ID: <44184AFA.5020109@trash.net>
References: <x7d5go53rf.fsf@speech.braille.uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Kirk Reiser <kirk@braille.uwo.ca>
In-Reply-To: <x7d5go53rf.fsf@speech.braille.uwo.ca>
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

CCed netfilter-devel.

Kirk Reiser wrote:
> Hi Folks:  I am either using the multiport of the -m or --match option
> of iptables in correctly or there is a bug with it.  Is anyone else
> using it with no problem?  This is the way I am trying to use it:
> 
> my_ports=21,25,80 
> iptables -t nat -A PREROUTING -i $wan_addr -p tcp -m multiport
> --dports $my_ports -j DNAT --to $my_internal_address
> 
> I have used this in the past successfully but that was a few years
> ago.  I get no errors or warnings it just ignors the ports.  The
> multiport invokation shows up in an iptables -t nat -L -v however.
> The packet and byte counts never get incremented either from zero.
> 
> Any pointers would sure be helpful, having to include a line for every
> port check seems wasteful.

Please post your kernel version, your iptables version and the
output of iptables -vxnL.
