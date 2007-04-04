From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables match rule for DNS RR?
Date: Wed, 04 Apr 2007 16:20:24 +0200
Message-ID: <4613B428.6000009@trash.net>
References: <20070404131825.GB20515@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Ross Vandegrift <ross@kallisti.us>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070404131825.GB20515@kallisti.us>
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

Ross Vandegrift wrote:
> Is there any netfilter work, either production or in development, that
> provides a way to filter traffic based on DNS RR type?


Not that I know of, but it shouldn't be very hard to write one.
