From: "Alex Bennee" <alex@bennee.com>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 14:56:18 +0100 (BST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <23233.195.99.244.6.1025013378.squirrel@www.bennee.com>
References: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
Reply-To: alex@bennee.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
In-Reply-To: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jean-Michel Hemstedt said:
> In my opinion, a first step should be to reconsider timeout values but
> also timer mechanisms.

I've been following this thread with interest as I recently also had
conntrack related problems (failing to establish new connections due to the
table being full).

My machine is resource contrained (28M RAM) as its only an ADSL gateway yet
when I count the number of connections its tracking it varies between
300->600 connections which bare little relation to what it should be.

I excacerbate the problem by running gtk-gnutella which entertains a lot of
short lived incomming connections that get closed by the application but
still create long-lived conntrack entries.

>> I'm against in changing the *default* timeout values, except when it
>> is based on real-life, well established cases.
>
> What sounds the most significant: 'TCP timeouts' or 'application
> timeouts'? Should (i.e) HTTP, FTP and Telnet have the same lifetime in
> hash?

Maybe a iptables marking approach (a-la tc)?


Alex
www.bennee.com/~alex/
