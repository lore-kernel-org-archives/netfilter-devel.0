From: "bruno.plantier@ensimag.imag.fr" <plantieb@ensisun.imag.fr>
Subject: Creating and adding a new patch.
Date: Tue, 17 Feb 2004 15:47:45 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.40.0402171459280.23205-100000@ensisun>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!,

first, please excuse me if this question as already been asked, but I red
all the faqs (including the Contributing part of the netfilter extension
HOWTO) and most of the mailing archive and couldnt find a full answer.

I am about to start the development of a patch in order to add some user
friendly netbus filtering rules into netfilter (not using u32, cause it'd
imply the user  knows the internal structure of a netbus packet).

Here are my questions:

1) I've red that the patching system have recently been updated from pom
to pom-ng, changing the structure of the patches. So i imagine the file
NEWPATCHES from Paul Russel is now obsoleted (no more .patch files
containing diff output?). I was wondering if there were (or will be?)
another file explaining the procedure to create a new patch (If there
isnt,  i imagine i would discover it by myself, thanks to the other
patches.. but I'd rather ask fist :) )

2) When  my patch will be done, what's the procedure to submit it in order
to share it with the community? I assume the cvs is read only for
anonymous  access, and only core developpers have write access. Do i need
to submit it on this mailing, contact someone or do something else special?

Thanks for your help,

Regards,

--
Bruno PLANTIER
