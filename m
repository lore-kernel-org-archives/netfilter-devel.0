From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Minor fix for patchlets which modify multiple projects
Date: Thu, 13 May 2004 20:08:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A3B9A8.2040202@trash.net>
References: <40A2754C.F4AA6CEF@info-link.net> <40A2E52C.3010103@trash.net> <40A39DC6.C3F78CA3@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <40A39DC6.C3F78CA3@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Brad Fisher wrote:
> 
> I don't think your patch is quite right.  You can end up having the same project listed multiple
> times with your patch, which is why I used the separate hash - key collisions are reduced to single
> entries.  I guess as long as it is no problem for a project to be processed multiple times, then
> your patch will be OK, but if that isn't the case, you may want to look into it again.

You're right, I just experienced that problem with the raw table patch.
Applying your original patch now, thanks.

Regards
Patrick
