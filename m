From: Patrick McHardy <kaber@trash.net>
Subject: Re: Negating limit
Date: Thu, 08 Jun 2006 09:36:12 +0200
Message-ID: <4487D36C.5060708@trash.net>
References: <44848BE1.1070503@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <44848BE1.1070503@anduras.de>
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

Sven Anders wrote:
> Here is a patch to allow a negated "limit", so we can match above and below the
> limit.
> 
> It adds a new "flags" variable after the burst. I'm not sure, if I can add it
> after the "*master" variable, so I added it here.
> Does this preserve compatibility, because anything after is only used by the kernel?

No, unfortunately there is no way to add a new variable to that struct
without breaking compatibility. You could add a new revision, but I
would like to think about Massimiliano Hofer's patch before that,
if we do something like that we can get rid of the "master" pointer
with the new revision.
