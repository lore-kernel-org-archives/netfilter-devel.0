From: =?iso-8859-1?q?graham=20g?= <grinna369@yahoo.com.au>
Subject: Re: distributed firewall
Date: Tue, 4 Feb 2003 12:11:05 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030204011105.65032.qmail@web13306.mail.yahoo.com>
References: <1044282321.25601.96.camel@rade7.s.cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <1044282321.25601.96.camel@rade7.s.cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

im just writing a client/server app where the server
sends out policy commands to client daemon processes,
which are interpreted by the daemon, which then
creates the necessary rules in iptables.

all logging info will be sent back to the server and
analysed to determine the next set of rules to be sent
out to clients


 --- Emmanuel Fleury <fleury@cs.auc.dk> wrote: > On
Mon, 2003-02-03 at 14:11, graham g wrote:
> > hi 
> > 
> > being new to this list, i just wanna know if
> anyone has had any
> > experience trying to build a distributed firewall
> using iptables /
> > libiptc. im currently working on such a project
> and just wanna know if
> > anyone has ever attempted anything similar
> 
> What do you call a 'distributed firewall' ?
> 
> -- 
> Emmanuel Fleury
> 
> Computer Science Department, |  Office: E4-112
> Aalborg University,          |  Phone:  +45 96 35 72
> 23
> Fredriks Bajersvej 7E,       |  Fax:    +45 98 15 98
> 89
> 9220 Aalborg East, Denmark   |  Email: 
> fleury@cs.auc.dk
> 
>  

http://movies.yahoo.com.au - Yahoo! Movies
- What's on at your local cinema?
