From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip6tables: Unknown error 4294967295
Date: Tue, 14 Mar 2006 17:54:26 +0100
Message-ID: <4416F542.6000404@trash.net>
References: <342126766.19325@ustc.edu.cn> <4416D92F.40103@certicom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	GuanYao Huang <gyhuang@mail.ustc.edu.cn>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chinh Nguyen <cnguyen@certicom.com>
In-Reply-To: <4416D92F.40103@certicom.com>
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

Chinh Nguyen wrote:
> net/ipv4/netfilter is a directory in the kernel source code. I took a quick peek
> at the latest kernel 2.6.16-rc6. I don't think there's any support for the
> "ROUTE" target in the kernel.
> 
> Can any netfilter developer confirm?

No, there isn't. But you still should not get this error.
Can you send a strace of the failing command please?
