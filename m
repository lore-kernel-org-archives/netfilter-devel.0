From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: Re: [RFC] iptables namespaces
Date: Sat, 8 Sep 2007 13:28:11 +0000
Message-ID: <20070908132810.GA19766@ekonomika.be>
References: <20070907180204.GA460@ekonomika.be>
	<20070907184642.GA4728@outback.rfc2324.org>
	<20070907190601.GA18714@ekonomika.be>
	<Pine.LNX.4.64.0709080924090.25942@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>,
	Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709080924090.25942@fbirervta.pbzchgretzou.qr>
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

On Sat, Sep 08, 2007 at 09:26:09AM +0200, Jan Engelhardt wrote:
> >iptables-restore takes a file as input, not a series of iptables
> >commands.
> 
> Yes, it takes a file. And if you looked at it, yes, it takes iptables
> commands! (besides the table and counter markers)
> 
> >This means I would have to edit the file manually, not
> >something I want to do with 7000 firewall rules.
> 
> Where is the difference between...
> 
> 	iptables -A INPUT -m foobar -j FOOBAR
> 
> and adding
> 
> 	-A INPUT -m foobar -j FOOBAR
> 
> to the
> 
> 	*filter
> 
> section? (Otherwise, write a script, as suggested, or use a GUI ;-)

Hi,

it's remarkable that we have never tried it this way before.
I tested adding 10000 lines with iptables, then using iptables-save and
iptables-restore. The difference in speed is amazing. With iptables it
takes 5 minutes and 10 seconds, while iptables-restore takes 0.3
seconds.

Moreover, if there is an error in iptables-restore, none of the changes
are committed to kernelspace. So I no longer need to use fancy checking
while I'm loading my firewall rules.

Thank you both for the information :)

kind regards,
-- Steven
