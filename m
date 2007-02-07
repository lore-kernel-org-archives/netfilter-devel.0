From: Andrew Beverley <andy@andybev.com>
Subject: Re: Unable to use MARK target with iptables-1.3.7
Date: Wed, 07 Feb 2007 16:10:31 +0000
Message-ID: <1170864632.4250.39.camel@andybev.localdomain>
References: <1170863326.4250.20.camel@andybev.localdomain>
	<45C9F835.7080806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Blake Covarrubias <blake@ekalb.net>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C9F835.7080806@netfilter.org>
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

> > When I try to use the MARK target with iptables 1.3.7:
> > 
> > iptables -t mangle -A POSTROUTING -p tcp --dport 22 -j MARK \
> > --set-mark 10
> > 
> > I get:
> > 
> > FATAL: Module ip_tables not found.
> > 
> > Is this a bug with 1.3.7 or am I doing something wrong?
> 
> Weird, this message comes from modprobe that is invoked by iptables.
> Does iptables -L -n show the rule that you just inserted?

Interesting, yes it does show the rule. I never thought to even check
because I got that nasty error message. If the rule is there then I
assume that everything is working? There's just the text of an error
message.

If it would help, and when I get some time, I can try with iptables as a
module instead of compiled in.

Andy Beverley
