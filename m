From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MAX_PORTS for ftp modules
Date: Tue, 27 Jan 2004 10:40:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401271038080.15264-100000@filer.marasystems.com>
References: <20040126211441.GA10833@66.27.62.2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nick Pasich <newsletters@NickAndBarb.net>
In-Reply-To: <20040126211441.GA10833@66.27.62.2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 26 Jan 2004, Nick Pasich wrote:

> I've exhausted the MAX_PORTS limit of 8 for ftp using my own port id.
> 
> I'm wondering if there are any repercussions in upping the limit to say,
> 16 in the following modules.

None I know of. But you should be careful to not register any ports wich 
is ever used for non-FTP traffic.

Note: TFTP is not the same as FTP, and ipfwadm is only relevant if your 
are using ipfwadm and is not related to your question.

Regards
Henrik
