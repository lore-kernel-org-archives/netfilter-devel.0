From: Kevin McConnell <kevymac@yahoo.com>
Subject: Re: Layer-7 HTTP Matching Module
Date: Fri, 7 Feb 2003 11:23:43 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030207192343.85533.qmail@web40309.mail.yahoo.com>
References: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kirk Bauer <kirk@kaybee.org>, netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- Kirk Bauer <kirk@kaybee.org> wrote:
> I think I could do this with the 'string' module of
> iptables -- i.e.
> look for the string "Content-type: text/html" and
> set a TOS flag or a
> firewall mark.  The 'tc' command can then be used to
> give these packets
> higher priority.
> 
> But I think it might be nice to have a true layer 7
> matching module.
> You could do:
> 
> -m --content-type 'text/html' --host
> 'www.mydomain.com'
> 
> It seems that if the string matching module is
> possible, then this is
> also possible.  

I'm sure anything's possible if you can imagine it.

> 
> Does such a module exist or is it being developed? 
> If not, I may write
> one when I have time if other people think it would
> be useful.

I don't see one being developed at this time, but I
think it would be useful.

> Kirk Bauer <kirk@kaybee.org>
> http://linux.kaybee.org | www.autorpm.org |
> www.logwatch.org

btw, thanks for so many years of use of both of these
great tools.


=====
Kevin C. McConnell --RHCE-- <Red Hat Certified Engineer>

__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
