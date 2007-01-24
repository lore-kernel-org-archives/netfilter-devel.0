From: Patrick McHardy <kaber@trash.net>
Subject: Re: rtsp conntrack compilation error 2.6.18
Date: Wed, 24 Jan 2007 18:38:11 +0100
Message-ID: <45B79983.8060107@trash.net>
References: <loom.20061225T094953-80@post.gmane.org>
	<45A48342.1050601@trash.net> <1f7f01c73fd8$4ede0f10$c202010a@Fiona>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: F Helmer <netfilter.20.fhelmer@spamgourmet.com>,
	netfilter-devel@lists.netfilter.org
To: Sverker Abrahamsson <sverker@abrahamsson.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1f7f01c73fd8$4ede0f10$c202010a@Fiona>
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

Sverker Abrahamsson wrote:
> I've been thinking many times to update the rtsp conntrack patch but
> where can I find information about changes in the API (except for
> reading diff's)? Are there any maintained API doc for netfilter?
> /Sverker

For helpers - no. Just look at a simple helper in the kernel (like
netbios-ns).
