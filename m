From: Kirk Bauer <kirk@kaybee.org>
Subject: Layer-7 HTTP Matching Module
Date: Tue, 4 Feb 2003 09:29:53 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0302040925160.12235-100000@kaybee.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I was thinking it would be nice to enhance my traffic shaping rules
(using 'tc') to make decisions about HTTP based on the type of content
being sent.  If, for example, the page has a content type of text/html,
I want it to be a fairly high priority.  Then, image/jpeg could be a
lower priority.

I think I could do this with the 'string' module of iptables -- i.e.
look for the string "Content-type: text/html" and set a TOS flag or a
firewall mark.  The 'tc' command can then be used to give these packets
higher priority.

But I think it might be nice to have a true layer 7 matching module.
You could do:

-m --content-type 'text/html' --host 'www.mydomain.com'

It seems that if the string matching module is possible, then this is
also possible.  

Does such a module exist or is it being developed?  If not, I may write
one when I have time if other people think it would be useful.

-- 
Kirk Bauer <kirk@kaybee.org>
http://linux.kaybee.org | www.autorpm.org | www.logwatch.org
