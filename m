From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ipt_entry_match and data field
Date: Fri, 7 May 2004 15:29:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405071528210.14348-100000@filer.marasystems.com>
References: <409B8A3C.1030009@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <409B8A3C.1030009@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 7 May 2004, Pablo Neira wrote:

> can anyone explain me the use of data as unsigned char in the structure 
> ipt_entry_match? I mean, why are we using unsigned char?

We are not. It is just a placeholder for the match extension. The actual 
data type and size differs depending on the match used.

Regards
Henrik
