From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Debian packages for libnfnetlink, libnetfilter-{queue,
 log, conntrack}, conntrack
Date: Sun, 27 Nov 2005 20:02:43 +0100
Message-ID: <438A02D3.3030203@trash.net>
References: <20051127173411.GA2031@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20051127173411.GA2031@roonstrasse.net>
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

Max Kellermann wrote:
> Hi,
> 
> I have created Debian packages for some of the new Netfilter userspace
> libraries / programs.  You can download them at my temporary
> repository:
> 
>  deb http://max.kellermann.name/download/netfilter/debian ./
>  deb-src http://max.kellermann.name/download/netfilter/debian ./
> 
> If nobody objects, I will try to bring these packages into Debian sid.
> Please test the packages and share your opinion!

Very nice, but please wait with trying to get them into
sid until we have resolved the CTA_PROTO_NUM issue.
