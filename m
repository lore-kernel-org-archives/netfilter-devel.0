From: Patrick McHardy <kaber@trash.net>
Subject: Re: Inquiry about Helper Modules
Date: Thu, 13 Jul 2006 10:03:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607131002270.15827@x2>
References: <1152667118.44b44dee8e86c@chang.cs.ubc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: haos05@cs.ubc.ca
In-Reply-To: <1152667118.44b44dee8e86c@chang.cs.ubc.ca>
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

On Tue, 11 Jul 2006, haos05@cs.ubc.ca wrote:

> Dear Sir/Madam,
>
> We plan to extend helper modules for application protocols which
> negotiate ports to use for data streams inside a control session.
> However, we have some confusions as below, your help will be highly
> appreciated.
>
> 1) It is mentioned in some documents, ftp session(and irc) has been
> implemented. Except for that, where can I find the complete list of
> protocols which have been implemented in help modules?
>
> 2) How can I get the detailed data structures and descriptions for
> funtions in the netfilter framework, especially related with helper
> modules (such as a programmer manual)? It is greater with some simple
> examples.
>
> 3) Where can I get the source code for ip_conntrack_ftp helper module?
> In the "Netfilter Hacking HOWTO", the command 'cvs -
> d :pserver:cvs@pserver.netfilter.org:/cvspublic login' and
> password 'cvs' doesn't work. It shows 'cvs [login aborted]: connect to
> pserver.netfilter.org(213.95.27.115):2401 failed: Connection refused'.
> The SVN server via command 'svn co
> https://svn.netfilter.org/netfilter/trunk/module' is not accessible
> either.
>> From the "Downloads" page, I
> downloaded 'conntrack', 'iptables', 'libnetfilter_conntrack' from
> ftp://ftp.netfilter.org/pub/ . They don't include ip_conntrack_ftp.

The kernel source is the only authorative source on this.
