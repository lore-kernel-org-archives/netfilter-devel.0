From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.11 corrupting FTP session
Date: Sun, 03 Apr 2005 17:58:17 +0200
Message-ID: <42501299.5010006@trash.net>
References: <1111176664.423b35d80b351@webmail.conectcor.com.br>
	<423DA1FB.6030209@trash.net>
	<1111341503.423db9bfcffb7@webmail.conectcor.com.br>
	<20050401060249.GI19835@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Michel Pereira <michel@michel.eti.br>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050401060249.GI19835@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> this sounds pretty straight forward, still i can't reproduce the problem
> at all. which ftp server and client are you using?

Me neither. I could trigger it totally unreliable, but couldn't figure
out what the problem is. My guess so far is that it is somehow related
to retransmissions.

Regards
Patrick
