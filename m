From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 12:25:36 -0800
Message-ID: <20050315202536.GA3928@linuxace.com>
References: <20050315050641.GA334@linuxace.com>
	<20050315172330.GA3130@linuxace.com> <4237369D.8080408@trash.net>
	<20050315194602.GA3487@linuxace.com> <42373D55.8020005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42373D55.8020005@trash.net>
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

On Tue, Mar 15, 2005 at 08:53:57PM +0100, Patrick McHardy wrote:
> Phil Oester wrote:
> >On a box with modular iptables, a DHCP interface, and NetworkManager
> >set to run on boot:
> 
> What is NetworkManager? Can I download the source somewhere?

It's suposed to manage network connections, choosing the best available
interface.  The SRPM for the version I'm testing with is available here:

http://mirrors.kernel.org/fedora/core/updates/3/SRPMS/NetworkManager-0.3.3-1.cvs20050119.2.fc3.src.rpm

Phil
