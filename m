From: Phil Oester <kernel@linuxace.com>
Subject: Re: 2.6.11 corrupting FTP session
Date: Sun, 3 Apr 2005 09:12:10 -0700
Message-ID: <20050403161210.GA25674@linuxace.com>
References: <1111176664.423b35d80b351@webmail.conectcor.com.br>
	<423DA1FB.6030209@trash.net>
	<1111341503.423db9bfcffb7@webmail.conectcor.com.br>
	<20050401060249.GI19835@sunbeam.de.gnumonks.org>
	<42501299.5010006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Michel Pereira <michel@michel.eti.br>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42501299.5010006@trash.net>
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

On Sun, Apr 03, 2005 at 05:58:17PM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
> >this sounds pretty straight forward, still i can't reproduce the problem
> >at all. which ftp server and client are you using?
> 
> Me neither. I could trigger it totally unreliable, but couldn't figure
> out what the problem is. My guess so far is that it is somehow related
> to retransmissions.

It is caused by TCP sequence adjustment problems -- see my email with subject
'[PATCH] Fix NAT TCP sequence adjustment'

Phil
