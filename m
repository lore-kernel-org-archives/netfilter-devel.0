From: "Nix N. Nix" <nix@go-nix.ca>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Tue, 17 Aug 2004 16:34:03 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092774843.10908.0.camel@dana.go-nix.ca>
References: <1092170081.9955.12.camel@dana.go-nix.ca>
	 <411A1F1D.7080804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <411A1F1D.7080804@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-08-11 at 09:29, Patrick McHardy wrote:
> How do filenames which contain a quotation mark look ? I assume the 
> quotation
> marks is escaped ? We should also handle this case.

I submitted another patch which addresses this issue in a previous
message a few days ago, however, I have received no feedback on it. 
Could somebody with a few minutes to spare please look it over ?

I'm fairly new to this list, so I'm not familiar with the process of
submitting patches, however, I would like this fix to eventually make it
into ip_conntrack_irc.c.

Please let me know what you think !
