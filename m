From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 1/14]: Fix non-existant config option CONFIG_NF_DEBUG
Date: Tue, 22 Jun 2004 01:20:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D76D21.90000@trash.net>
References: <20040621193851.GF24374@sunbeam.de.gnumonks.org>	<20040621144452.15fbe009.davem@redhat.com>	<20040621224456.GJ24374@sunbeam.de.gnumonks.org> <20040621160138.2738c8e1.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20040621160138.2738c8e1.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

David S. Miller wrote:
> The person who codes the patch (in this case Patrick), the person
> who first integrates it (you) and me all have to sign off on the
> patch.
> 
> I don't care if you use bitkeeper or not, but you have to give me
> the Signed-off-by: lines in your email descriptions or someplace
> similar.

In this case Harald just passed the patchset on, so all mistakes are
mine. The 2.4 patches didn't include any Signed-off-by: lines because
I was under the impression that Marcelo doesn't require them. All 2.6
patches had them at the end of the patch description, but I'll be happy
to include them directly in the changeset comments next time I prepare
a patchset.

Regards
Patrick
