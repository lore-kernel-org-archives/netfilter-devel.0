From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 6 May 2004 15:47:46 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405061546210.24101@chris.camcom.co.uk>
References: <20040505065402.GA18440@hamachi.radom.org> <409A4BBB.9080401@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@radom.org, Henrik Nordstrom <hno@marasystems.com>,
        KOVACS Krisztian <hidden@balabit.hu>,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <409A4BBB.9080401@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

> Please, if I'm missing something, kill me softly. Is there anything 
> wrong in fixing up the problem with the following patch?

Yes, unfortunately. The rate limit is supposed to be per-rule, not global. 
If you do this then you can't really use more than one limit rule 
in your ruleset, or you will get very unpredictable results (and very 
different from the current behaviour).

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
