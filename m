From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: fixed the bug of tracking TCP sequence number in ftp
 module
Date: Thu, 10 Mar 2005 02:53:15 +0100
Message-ID: <422FA88B.6080509@trash.net>
References: <200503092146.j29LkY7a006055@toshiba.co.jp>
	<422F6FF3.2080603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <422F6FF3.2080603@trash.net>
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

Yasuyuki KOZAKAI wrote:

> TCP sequence number is 32bits. 

BTW, I have a nf_conntrack tree outside of patch-o-matic to get it ready
for submission. I haven't exported it anywhere public yet, but since
you're updating nf_conntrack anyway, it would be great if you could also
send patches for nf_conntrack against your tree together with
ip_conntrack patches. I'll try to export my tree somewhere this
weekend.

Thanks,
Patrick
