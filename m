From: Willy TARREAU <willy@w.ods.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 16:54:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229155400.GA28077@pcw.home.local>
References: <20040229150335.GB23662@pcw.home.local> <MJEGLLMOCKDFLDKPELCNOEBPCCAA.stevec3@bellsouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Steve Croom III <stevec3@bellsouth.net>
Content-Disposition: inline
In-Reply-To: <MJEGLLMOCKDFLDKPELCNOEBPCCAA.stevec3@bellsouth.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Feb 29, 2004 at 10:21:11AM -0500, Steve Croom III wrote:
> Willy,
> 
> I am very interested in this little script. 
> Where can I aquire it at or if you dont mind sending it to me.

OK, I've put it there :

   http://w.ods.org/tools/netfilter/

You need to start it from the patch-o-matic-ng directory.
If you run it with '-n', it will display the patches in the patches
in this directory which the script does not know about. Then you
simply cut'n'paste the pre-formated entries into the script.
Warning: it doesn't handle missing patches, it's very elementary.

Then you start it with '-a', and it applies all patches prefixed
with a '+' at once with 'runme'. You'll also have to set the
KERNEL_DIR and IPTABLE_DIR variables, or change them in the script
itself.

Hoping this helps,
Willy
