From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq does not shorten package
Date: Thu, 09 Mar 2006 16:55:35 +0100
Message-ID: <44104FF7.1030104@trash.net>
References: <859616420603090530p24d0cb9cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <beunlovable@gmail.com>
In-Reply-To: <859616420603090530p24d0cb9cg@mail.gmail.com>
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

David Vogt wrote:
> Dear all,
> 
> I already posted this question on netfilter mailing list, however, I
> got no response, so maybe someone around here can help me.
> 
> I am using iptables and queue packets to user space. Packets are
> either augmented (with a signature) or shortened (removal of
> signature). The augmentation works.
>  However, when removing the signature, the resulting packet contains
> the correct data, but its overall size is equal to the original
> (signed) packet. (i.e. original packet size: 83, signed packet size:
> 163)

Thomas Graf posted a patch that should fix this a couple of days
ago, check the list archives.
