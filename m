From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ip_queue questions
Date: Sat, 26 Mar 2005 12:46:01 +0100
Message-ID: <42454B79.6000305@eurodev.net>
References: <42450A7E.8050404@ufh.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
To: Peter Enderborg <pme@ufh.se>
In-Reply-To: <42450A7E.8050404@ufh.se>
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

Peter Enderborg wrote:
> I whould like to do something similar to the MARK, just modify the data 
> and then continue.

Look for ip_queue_vwmark in pom-ng, that enables the nfmark modification.

AFAIK that patch surely won't ever get in kernel mainline since there's 
a more simple way to export nfmark (just adding it to the message). This 
  breaks backward compatibility with current application though.

--
Pablo
