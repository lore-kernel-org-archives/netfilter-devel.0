From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] POM-NG OSF match - missing header
Date: Sun, 22 Aug 2004 00:00:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4127C5F5.1020801@trash.net>
References: <20040820225437.GA25659@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040820225437.GA25659@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>The 2.6 directory is missing the osf.h header.  Copied the 2.4 version, and
>added a missing include while there.  Build tested on 2.6.8.1.
>
>This fixes bugzilla #234
>  
>

Applied, thanks for taking on all these bugzilla bugs :)

Regards
Patrick
