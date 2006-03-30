From: Amin Azez <azez@ufomechanic.net>
Subject: Re: iptables-xml userland tool and feedback
Date: Thu, 30 Mar 2006 09:44:47 +0100
Message-ID: <442B9A7F.1010609@ufomechanic.net>
References: <400E4214.1070100@googgun.com> <40102E84.3090904@googgun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Elf King <elf@googgun.com>
In-Reply-To: <40102E84.3090904@googgun.com>
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

Elf King wrote:
> Hello Harald and all netfilter devers:
> 
> Harald, not sure if you got a chance to see my post about an 
> iptables-xml utility. If not have a glance at 
> http://www.googgun.com/iptables-xml/.

Ahmed, are you still about?
I see that iptables-xml has recently vanished from googgun.com

I've just produced some bash scripts that convert iptables-save to xml 
format (bash! indeed! see some of the tricks it uses!) and am doing xslt 
to convert back to iptables-save format.

The reason for this is that it is easy to transform and merge rulesets 
with xslt than perl and friends, thanks to xpath etc.

I'm anxious (as Harald hints) not to introduce yet-another-format, hence 
the full round-tripping support for the format.

Naturally the XML schema is so close to the iptables argument format (a 
very simple transform) that a native incorporation (should it ever be 
worthwhile) is trivial.

Sam
