From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] pom-ng version of IMQ target (file is attached this time)
Date: Thu, 13 May 2004 04:13:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A2D9D8.2050201@trash.net>
References: <40A29E4A.94165870@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linuximq@yahoogroups.com, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <40A29E4A.94165870@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Brad,

Brad Fisher wrote:

>(Sorry for the duplicate post, forgot to attach the file... doh)
>
>Attached is a pom-ng version of the IMQ target available from
>linuximq.org.  It's based off the 2.4.26 patch, and includes all of the
>kernel (linux-2.4.26-imq.diff) and userspace patches (IMQ.pom-ng.patch).
>  
>

Andre Correa already asked me about inclusion of the IMQ target. I would
rather not include at this time it for two reasons:

- IMQ still has stability problems
- Jamal is working on a netfilter-independant replacement, I would like to
see how it works out first. See 
http://marc.theaimsgroup.com/?t=108202471500003&r=1&w=2

Regards
Patrick
