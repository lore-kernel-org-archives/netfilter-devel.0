From: Allen <aef@prismnet.com>
Subject: IMHO - Re: Deleting Connection Tracking information
Date: Mon, 8 Jul 2002 23:49:17 +0000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708234917.9B08E2A@bob.localdomain>
References: <AE696B0F5B44A348B8D18E40F976D9571BA92E@mailsrv.etagon.com> <200207081143.g68Bh6806571@vulcan.rissington.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Antony Stone <Antony@Soft-Solutions.co.uk>,
	<netfilter-devel@lists.samba.org>
In-Reply-To: <200207081143.g68Bh6806571@vulcan.rissington.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Monday 08 July 2002 11:43 am, Antony Stone wrote:
> On Monday 08 July 2002 1:31 pm, Tsachi Sharfman wrote:

snips

> However, a more serious problem is what do you possibly want to change in
> the NAT rules for a connection which is currently in progress, which isn't
> going to seriously upset either the client or the server on the ends of the
> connection ?


I have to say something about this.

Remember Mosix ?

One of the things 'they' are supposed to be working on is a sort of
"portable socket".

This makes for at least interesting if not all out fantastic cluster 
applicability to lots of different "solutions".

1.  Mosix massive web server that would be hard to kill...

    Right dandy scalability, reliability, *.ility...

2.  Big Ole RDBMS that keeps you alive at almost all costs... ;)

3.  Etc.,

This whole concept *may* be entirely out of scope... but then again,
maybe not...

2 cents.

-AEF
