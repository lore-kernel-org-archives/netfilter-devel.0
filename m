From: Pablo Neira <pablo@eurodev.net>
Subject: Re: TCP conntrack queries
Date: Mon, 22 Mar 2004 11:21:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405EBE19.8050209@eurodev.net>
References: <20040322050438.56577.qmail@web14009.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar <immidi_kiran@yahoo.com>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20040322050438.56577.qmail@web14009.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

Kiran Kumar wrote:

>Hi,
>  As I went through ip_conntrack_proto_tcp.c, I had
>these couple of queries.
>
>- Why is there a distinction b/w states NONE and
>CLOSED?
>  
>
None is the initial state where every connection starts when a conntrack 
is created and Close is when closed connection (I know, quite obvious!).

Anyway have a look at tcp-window-tracking patch because Jozsef spent its 
time well-documenting all the possible transitions to let us understand :).

>- The array of timeouts has been replaced (as I get
>from the diff b/w my RH9 kernel sources and 2.6
>sources) by an array of pointers to variables. Why was
>this done?
>  
>
because now you can set your own timeouts via sysctl.

regards,
Pablo
