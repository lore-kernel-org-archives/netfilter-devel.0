From: Eric Leblond <eric@inl.fr>
Subject: Re: packet reordering with libipq
Date: Sun, 20 Jun 2004 11:27:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087723631.3365.5.camel@coati>
References: <20040620070744.33536.qmail@web54102.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: DeveloperList Netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Weiguang Shi <wgshi2002@yahoo.ca>
In-Reply-To: <20040620070744.33536.qmail@web54102.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2004-06-20 at 09:07, Weiguang Shi wrote:
> Hi
> 
> I have a quick question about libipq. 
> 
> After I read a packet at  userspace, must I call 
> ipq_set_verdict() before I can read another?

Quick answer : No
You can thus reorder packets ....

BR,
-- 
Eric Leblond <eric@inl.fr>
INL
