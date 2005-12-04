From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: libconntrack usage
Date: Sun, 04 Dec 2005 01:48:15 +0100
Message-ID: <43923CCF.1000306@eurodev.net>
References: <1133656782.17460.11.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1133656782.17460.11.camel@porky>
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

Hi Eric,

Eric Leblond wrote:
> INL has develop a daemon (nutrackd) which use the libconntrack. It opens
> event handler for DESTROY event and to register the callback it uses :
> 	nfct_register_callback(cth, update_handler, NULL);
> and this work well, our handler is called.
> 
> But is still display [DESTROY] on stdout after each message.
> 
> By doing :
>     nfct_unregister_callback(cth);
>     nfct_register_callback(cth, update_handler, NULL);
> we manage to suppress the useless message.
> 
> Is this a bug or a feature ?

Curiously I noticed that some hours ago, I fixed in the last SVN commit
together with some changes. That will fix your problem. Check out a
working copy from SVN.

BTW, nfct_event_display_handler doesn't exist anymore, now you have to
use nfct_conntrack_display_handler instead.

cheers.

-- 
Pablo
