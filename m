From: AllKind <AllKind@fastest.cc>
Subject: Re: [RFC nftables PATCH] nft: add bash completion script
Date: Sat, 6 Feb 2016 21:13:02 +0100
Message-ID: <56B653CE.1020005@fastest.cc>
References: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
Reply-To: AllKind@fastest.cc
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55469 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbcBFUND (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Feb 2016 15:13:03 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 967C320186
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Feb 2016 15:13:02 -0500 (EST)
In-Reply-To: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.02.2016 17:53, Giuseppe Longo wrote:
> The following patch adds a bash completion script
> which permits to complete nft commands.
>
> To install it:
> - cp files/nft-completion /etc/bash_completion.d/
> - . /etc/bash_completion.d/nft-completion
[...]


Another thing - reading the README of bash completion 2.1, this behavior 
is deprecated and just kept for backwards compatibility.
Since 2.0 dynamic loading of completion is supported and quoting the 
readme it should be done like this:

Q. I author/maintain package X and would like to maintain my own
    completion code for this package. Where should I put it to be sure
    that interactive bash shells will find it and source it?

    Install it in one of the directories pointed to by
    bash-completion's pkgconfig file variables.  There are two
    alternatives: the recommended one is 'completionsdir' (get it with
    "pkg-config --variable=completionsdir bash-completion") from which
    completions are loaded on demand based on invoked commands' names,
    so be sure to name your completion file accordingly, and to include
    for example symbolic links in case the file provides completions
    for more than one command.  The other one which is present for
    backwards compatibility reasons is 'compatdir' (get it with
    "pkg-config --variable=compatdir bash-completion") from which files
    are loaded when bash_completion is loaded.

    For packages using GNU autotools the installation can be handled
    for example like this in configure.ac:

      PKG_CHECK_VAR(bashcompdir, [bash-completion], [completionsdir], ,
        bashcompdir="${sysconfdir}/bash_completion.d")
      AC_SUBST(bashcompdir)

    ...accompanied by this in Makefile.am:

      bashcompdir = @bashcompdir@
      dist_bashcomp_DATA = # completion files go here

    For cmake we ship the bash-completion-config.cmake and
    bash-completion-config-version.cmake files. Example usage:

      find_package(bash-completion)
      if(BASH_COMPLETION_FOUND)
        message(STATUS
          "Using bash completion dir ${BASH_COMPLETION_COMPLETIONSDIR}")
      else()
        set (BASH_COMPLETION_COMPLETIONSDIR "/etc/bash_completion.d")
        message (STATUS
          "Using fallback bash completion dir 
${BASH_COMPLETION_COMPLETIONSDIR}")
      endif()

      install(FILES your-completion-file DESTINATION
        ${BASH_COMPLETION_COMPLETIONSDIR})


Best regards,
AllKind

