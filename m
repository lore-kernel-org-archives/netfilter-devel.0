From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:53:52 +0200
Message-ID: <200608141753.53072.max@nucleus.it>
References: <44E07BCD.8030206@trash.net> <44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814152026.GU7194@kriss.csbnet.se>
Content-Disposition: inline
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

On Monday 14 August 2006 5:20 pm, Joakim Axelsson wrote:

> Lost? Like the memory will be reallocated and we have a memory leak from
> the old priv_data?

No.
Every time a modification is done a complete new chain is created and 
initialized, swapped for the current one and then the old one is removed.
This means that any memory needed by priv_data is reallocated for the new 
chain end than freed while destroying the old one.
My patch doesn't care since I keep a global list where I can fetch my data 
back using the condition name and use priv_data only as a way to keep it at 
hand and achieve O(1) performance.
If you don't have an alternative means to retrieve your data I'm afraid you'r 
bust. :(
I agree with Patrick and I think it's time to think about other ways to manage 
changes.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
