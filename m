From: AllKind <AllKind@fastest.cc>
Subject: Re: [RFC nftables PATCH] nft: add bash completion script
Date: Sat, 6 Feb 2016 08:56:18 +0100
Message-ID: <56B5A722.10007@fastest.cc>
References: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
Reply-To: AllKind@fastest.cc
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37100 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbcBFH4X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Feb 2016 02:56:23 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 11BD020678
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Feb 2016 02:56:20 -0500 (EST)
In-Reply-To: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.02.2016 17:53, Giuseppe Longo wrote:
> The following patch adds a bash completion script
> which permits to complete nft commands.

Hello,

ok you've been quicker than me. Now that I'm quite done with the 
iptables completion:
https://sourceforge.net/projects/ipt-bashcompl
https://github.com/AllKind/iptables-bash_completion
I wanted to start with nft... But well, you might find one or the other 
piece of code useful to reuse i.e. retrieving interface names.
>
> To install it:
> - cp files/nft-completion /etc/bash_completion.d/
> - . /etc/bash_completion.d/nft-completion
>
> The following commands are supported:
> - nft add table <family> <name>
> - nft list table <family> <name>
> - nft list tables
> - nft list sets
> - nft list chains
> - nft list ruleset
> - nft list set <table> <name>
> - nft add set <table> <name>
> - nft add element <table> <set>
> - nft add map <table>
> - nft flush table <family> <table>
>
> Most probably this won't work with sudo, since there
> are some nft commands into the script.

Untested, but from what I read in the bash_completion package (2.1), 
it's capable of loading the completion for the command after sudo (using 
the function _command_offset() ).
>
> A second patch to add completion in interactive mode
> will come.
>
> This is only a draft,
> any feedback is appreciated.
>
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>   files/nft-completion | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 60 insertions(+)
>   create mode 100644 files/nft-completion
>
> diff --git a/files/nft-completion b/files/nft-completion
> new file mode 100644
> index 0000000..c138312
> --- /dev/null
> +++ b/files/nft-completion
> @@ -0,0 +1,60 @@
> +_nft()
> +{
> +    local cur prev
> +    COMPREPLY=()
> +    cur="${COMP_WORDS[COMP_CWORD]}"
> +    prev="${COMP_WORDS[COMP_CWORD-1]}"
> +

Are you planing to make use of the functionality of the bash_completion 
package? As it may contain some useful stuff.

> +    local families="ip ip6 arp bridge inet netdev"
> +    local sets=$(nft list sets | grep -i "set" | awk '{print $2 }' | tr -d ' ')
> +
> +    if [ $COMP_CWORD -eq 1 ]; then
> +        COMPREPLY=( $(compgen -W "add flush list" -- $cur) )
> +    elif [ $COMP_CWORD -eq 2 ]; then
> +        case "$prev" in
> +            "add")
> +                command="${prev}"
> +                COMPREPLY=( $(compgen -W "element map table set" -- $cur) )
> +                ;;
> +            "list")
> +                COMPREPLY=( $(compgen -W "chains ruleset set sets table tables" -- $cur) )
> +                ;;
> +            "flush")
> +                COMPREPLY=( $(compgen -W "table" -- $cur) )
> +                ;;
> +            *)
> +                ;;
> +        esac

Using `case' statements makes it harder to debug, as bash does not show 
which case it matched. Using `if' `elif' improves this. Also this is one 
of the  coding style guidelines of bash_completion, in case you ever 
want it to go there.

> +    elif [ $COMP_CWORD -eq 3 ]; then
> +        case "$prev" in
> +            "table")
> +                COMPREPLY=( $(compgen -W "${families}" -- $cur) )
> +                ;;
> +            "set"|"element"|"map")
> +                local tables=$(nft list tables | awk '{print $3 }' | tr -d ' ')
> +                COMPREPLY=( $(compgen -W "${tables}" -- $cur) )
> +                ;;
> +            *)
> +                ;;
> +        esac
> +    elif [ $COMP_CWORD -eq 4 ]; then
> +        local tables=$(nft list tables | awk '{print $3 }' | tr -d ' ')
> +        if [[ "$families" =~ "$prev" ]]; then
> +            local tables=$(nft list tables "${prev}" | awk '{print $3 }' | tr -d ' ')
> +            COMPREPLY=( $(compgen -W "${tables}" -- $cur) )
> +        fi
> +
> +        if [ "${COMP_WORDS[1]}" != "add" ] && [[ "$tables" =~ "$prev" ]]; then

Probably you can save some typing with:
[[ a != b && x =~ y ]]

> +            COMPREPLY=( $(compgen -W "${sets}" -- $cur) )
> +        fi
> +
> +        if [ "${COMP_WORDS[1]}" == "add" ] && [ "${COMP_WORDS[2]}" == "element" ] && [[ "$tables" =~ "$prev" ]]; then
> +            COMPREPLY=( $(compgen -W "${sets}" -- $cur) )
> +        fi
> +    fi
> +
> +    return 0;
> +}
> +
> +complete -F _nft nft
> +
>

Good day,
AllKind

