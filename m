From: Patrick McHardy <kaber@trash.net>
Subject: Re: fix compile error in IPv6 versions of nth and random modules
Date: Wed, 29 Mar 2006 10:37:26 +0200
Message-ID: <442A4746.7030606@trash.net>
References: <427c54c0603280922x38225874wa300ab9f07fd8ddb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel De Graaf <danieldegraaf@gmail.com>
In-Reply-To: <427c54c0603280922x38225874wa300ab9f07fd8ddb@mail.gmail.com>
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

Daniel De Graaf wrote:
> When compiled for IPv6, the nth and random modules produce compile
> errors because of a change in the ip6t_match structure. These patches
> fix that error and a related warning about incompatible types. Since
> the patches are nearly identical, I am posting them together; sorry if
> this is a problem.

Applied, thanks. Unfortunately 2.6.17 will require another patch ..

BTW:

Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Disposition: inline

...

Content-Type: application/octet-stream; name=diff
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_elchtr7v
Content-Disposition: attachment; filename="diff"

Please make sure the plain patch is sent inline so it can be viewed in
the mail client without saving first.
