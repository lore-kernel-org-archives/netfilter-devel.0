From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating and adding a new patch.
Date: Tue, 17 Feb 2004 17:27:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171722140.1545-100000@filer.marasystems.com>
References: <Pine.GSO.4.40.0402171657090.29096-100000@ensisun>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bruno PLANTIER <bruno.plantier@ensisun.imag.fr>
In-Reply-To: <Pine.GSO.4.40.0402171657090.29096-100000@ensisun>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Bruno PLANTIER wrote:

> 1) I've red that the patching system have recently been updated from pom
> to pom-ng, changing the structure of the patches.

Indeed.

> So i imagine the file NEWPATCHES from Paul Russel is now obsoleted (no
> more .patch files containing diff output?). I was wondering if there
> were (or will be?) another file explaining the procedure to create a new
> patch (If there isnt, i imagine i would discover it by myself, thanks to
> the other patches.. but I'd rather ask fist :) )

The pom-ng is somewhat simpler in structure, in most cases having flat 
files. There is a start of a README.newpatches document these days, but a 
lot remains to document.

pom-ng retains much of the special edit functions of pom to slot in 
Makefile, Configure.help etc entries. These files nowdays go into the 
extension directory structure mostly where the file to be edited resides. 
Until the README.newpatches document is complete the best source of 
information is to look at a couple of the existing pom-ng extensions while 
remembering the information about special files from the old NEWPATCHES 
document. The principle is the same, just the file naming differs.

> 2) When my patch will be done, what's the procedure to submit it in
> order to share it with the community? I assume the cvs is read only for
> anonymous access, and only core developpers have write access. Do i need
> to submit it on this mailing, contact someone or do something else
> special?

The normal procedure is to send it to the mailinglist.

Regards
Henrik
