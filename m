From: Phil Oester <kernel@linuxace.com>
Subject: Re: 2.6.11 corrupting FTP session
Date: Sat, 2 Apr 2005 11:57:05 -0800
Message-ID: <20050402195705.GA2888@linuxace.com>
References: <1111176664.423b35d80b351@webmail.conectcor.com.br>
	<423DA1FB.6030209@trash.net>
	<1111341503.423db9bfcffb7@webmail.conectcor.com.br>
	<20050401060249.GI19835@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.62.0504022105520.19574@nike.zcu.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Milos Wimmer <wimmer@zcu.cz>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0504022105520.19574@nike.zcu.cz>
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

On Sat, Apr 02, 2005 at 09:31:13PM +0200, Milos Wimmer wrote:
>  I have same problem (see Bug #308).
> 
> When I'm running kernel 2.4.x and 2.6.0-2.6.10 kernel on the firewall,
> active ftp session on the client works fine. When I'm running 2.6.11,
> 2.6.11.x and 2.6.12-rc1 kernel on the firewall box, active ftp session
> with "mget *" command fails after 6 transfered files.
> Passive ftp session works fine on any kernel.

I'll post a patch for this shortly -- I've tracked it down to a TCP
sequence adjustment problem.

Phil
