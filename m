From: Pablo Neira <pablo@eurodev.net>
Subject: Re: blocking/allowing particular protocol
Date: Wed, 17 Mar 2004 12:17:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405833B5.1020800@eurodev.net>
References: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Kumar Shobhit (IFIN DC COM)" <Shobhit.Kumar@infineon.com>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Kumar Shobhit (IFIN DC COM) wrote:

> For example, HTTP can work on various ports, So instead of 
> blocking/allowing a particular port
> can I allow/block HTTP itself i.e to allow HTTP traffic on any port.

You could have a look at:

http://l7-filter.sourceforge.net/

Actually, I didn't even try it, so don't blame me.

regards,
Pablo
