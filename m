From: Pablo Neira <pablo@eurodev.net>
Subject: Re: comments about ip_conntrack_in function
Date: Sat, 06 Mar 2004 01:12:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40491785.1070204@eurodev.net>
References: <40452A57.3060209@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <40452A57.3060209@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> c) I don't know so much about the set_bit function and its 
> implementation but, while setting the status of a conntrack already 
> inserted, don't we need to write_lock the conntrack hash table?

please ignore this question.

Pablo
