From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [NETFILTER] Remove BUG_ON() in destroy_conntrack()
Date: Thu, 02 Feb 2006 15:47:35 +0100
Message-ID: <43E21B87.6020509@trash.net>
References: <11388803061179-git-send-email-heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
In-Reply-To: <11388803061179-git-send-email-heitzenberger@astaro.com>
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

Holger Eitzenberger wrote:
> Remove BUG_ON(list_empty(...)) check in destroy_conntrack because
> it is perfectly valid for conntracks to be in no list at all, e. g.
> if ct_sync is used.

This should stay in the ct_sync patchset until it is merged.
