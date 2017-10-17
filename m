From: "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>
Subject: Problem compiling nftables
Date: Tue, 17 Oct 2017 13:19:28 -0400
Message-ID: <20171017171928.GJ6963@ubuntu-server-1604>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:47902 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757622AbdJQRTc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 13:19:32 -0400
Received: by mail-vk0-f51.google.com with SMTP id j2so1595632vki.4
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 10:19:31 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I trying to install nftables from source ask part of my Outreachy application tasks. I already installed libmnl and libnftnl successfully.

The problem comes after the 'make' command while trying to compile nftables. I'm running Ubuntu 16.04 and following the steps described here: https://wiki.nftables.org/wiki-nftables/index.php/Building_and_installing_nftables_from_sources

I removed the last commit of the nftables master branch: 8dee5e43ad4beb2b0a95e0bbf2b3972630c1b327 'netlink: Use nftnl_expr_fprintf() in netlink_dump_expr()', to avoid a compilation error because a dependency with a libnftnl's patch still pending to apply. But the following error is beyond my skills right now and maybe is just a detail that I'm missing and somebody can help me.

Thanks in advance
frank

Here is the relevant make output:

...
make[3]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/include/linux'
make[3]: Entering directory '/home/vagrant/git/pablo/nftables/nftables/include'
make[3]: Nothing to be done for 'all-am'.
make[3]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/include'
make[2]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/include'
Making all in doc
make[2]: Entering directory '/home/vagrant/git/pablo/nftables/nftables/doc'
  GEN      nft.8
Usage: jw [<options>] <sgml_file>
where <options> are:
  -f|--frontend <frontend>: 	 Specify the frontend (source format)
  				 (default is docbook)
  -b|--backend <backend>: 	 Specify the backend (destination format)
  				 (default is html)
  -c|--cat <file>: 		 Specify an extra SGML open catalog
  -n|--nostd: 			 Do not use the standard SGML open catalogs
  -d|--dsl <file>|default|none:	 Specify an alternate style sheet
  				 (default is to use the default stylesheet)
  -l|--dcl <file>: 		 Specify an alternate SGML declaration
  				 (usual ones like xml.dcl get detected automatically)
  -s|--sgmlbase <path>: 	 Change base directory for SGML distribution
  				 (usually /usr/share/sgml)
  -p|--parser <program>: 	 Specify the parser if several are installed
  				  (jade or openjade)
  -o|--output <directory>: 	 Set output directory
  -u|--nochunks: 		 Output only one big file
  				 (overrides the stylesheet settings)
  -i|--include <section>: 	 Specify a SGML marked section to include
  				 (should be marked as "ignore" in the SGML text)
  -w|--warning <warning_type>|list: Control warnings or display the allowed warning types
  -e|--errors <error_type>|list: Control errors or display the allowed error types
  -h|--help: 			 Print this help message and exit
  -V <variable[=value]>: 	 Set a variable
  -v|--version: 		 Print the version and exit
Makefile:539: recipe for target 'nft.8' failed
make[2]: *** [nft.8] Error 1
make[2]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/doc'
Makefile:397: recipe for target 'all-recursive' failed
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables'
Makefile:338: recipe for target 'all' failed
make: *** [all] Error 2
