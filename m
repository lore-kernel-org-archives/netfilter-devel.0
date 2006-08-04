From: Thomas Heinz <thomasheinz@gmx.net>
Subject: Re: Ipsec, policy match and PROTO=4
Date: Fri, 4 Aug 2006 22:57:24 +0200
Message-ID: <200608042257.25461.thomasheinz@gmx.net>
References: <200607270131.18655.thomasheinz@gmx.net>
	<44D3A41C.9080606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44D3A41C.9080606@trash.net>
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

Hi Patrick

Thanks for your reply.

You wrote:
> The cleartext packet should also be seen with the real protocol after
> that.

Oh, you're right. Sorry for being so unobservant.

Is the fact that the packet with PROTO=4 is seen in between the encrypted 
and cleartext packet considered a bug?


Best regards,

Thomas
