From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Patch Errors
Date: 07 Apr 2003 20:27:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049740037.26440.189.camel@tux.rsn.bth.se>
References: <NGBBLGFEALDADHNDAAFFAEFLDJAA.ksmith@perfht.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin Smith <ksmith@perfht.com>
In-Reply-To: <NGBBLGFEALDADHNDAAFFAEFLDJAA.ksmith@perfht.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-04-07 at 20:14, Kevin Smith wrote:
> I was wondering where I can get a list of error codes patch o matic uses.
> What is error 1 and error 2 mean? 

Error codes patch-o-matic uses?

Do you mean errorlevel when the runme script terminates?
If so then it's 0 for no error and 1 for an error.

Do you get any errors when applying patches from patch-o-matic?
Just curious since I'm the patch-o-matic maintainer :)

-- 
/Martin
